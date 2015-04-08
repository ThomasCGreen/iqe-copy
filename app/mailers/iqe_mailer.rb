# class for mailing to client and coaches
class IqeMailer < ActionMailer::Base
  require 'csv'
  include QtestHelper
  default from: 'Results@InnovationQuotientTest.com'

  def results_email(qtest, pdf)
    @qtest = qtest
    @trigger_weights = qtest.trigger_weights

    pdf_file_name = "#{qtest.first_name}_#{qtest.last_name}_"\
                    'Innovation_Quotient_Edge_Results.pdf'
    attachments[pdf_file_name] = pdf.render
    subject = 'IQE Results'
    subject = '[NOT SENT TO CLIENT] ' + subject unless @qtest.send_to_client
    subject = 'PROMO: ' + subject if @qtest.free_test
    mail(to: @qtest.coach_email, subject: subject)
  end

  def results_to_client_email(qtest, pdf)
    @qtest = qtest
    pdf_file_name = "#{qtest.first_name}_#{qtest.last_name}_"\
                    'Innovation_Quotient_Edge_Results.pdf'
    attachments[pdf_file_name] = pdf.render
    mail(to: @qtest.email, subject: 'Innovation Quotient Edge (IQE) Results')
  end

  def promo_to_client_email(qtest)
    @qtest = qtest
    mail(to: @qtest.email,
         from: 'Tamara@TheShuuk.com',
         bcc: @qtest.coach_email,
         subject: '[Your IQE Link] Test Drive Innovation Quotient '\
         'Edge (IQE)')
  end

  def create_licenses_to_coach_email(license_quantity,
                                     licenses,
                                     send_to_client,
                                     multiuse_license,
                                     coach_first_name,
                                     coach_last_name,
                                     coach_email)
    @licenses = licenses
    @license_quantity = license_quantity
    @send_to_client = send_to_client
    @multiuse_license = multiuse_license
    @coach_first_name = coach_first_name
    @coach_last_name = coach_last_name
    @coach_email = coach_email
    csv_file_name = 'IQE_licenses_as_links.csv'
    csv_string = CSV.generate do |csv|
      @licenses.each do |license|
        csv << ['http://InnovationQuotientTest.com/taketest/' + license]
      end
    end
    attachments[csv_file_name] = csv_string
    mail(to: coach_email,
         subject: 'Licenses for Innovation Quotient Edge Assessments')
  end

  def create_licenses_email(license_quantity,
                            licenses,
                            send_to_client,
                            multiuse_license,
                            coach_first_name,
                            coach_last_name,
                            coach_email)
    @license_quantity = license_quantity
    @licenses = licenses
    @send_to_client = send_to_client
    @multiuse_license = multiuse_license
    @coach_first_name = coach_first_name
    @coach_last_name = coach_last_name
    @coach_email = coach_email
    mail(to: ENV['IQE_COACH_EMAIL'],
         subject: 'Licenses Sent To Coach')
  end

  def send_report(report, infusionsoft)
    @report = report
    @infusionsoft = infusionsoft
    subject = 'IQE Report'
    ok = true
    x_priority = 3  # normal
    importance = 'Normal'
    late_completions =  @report['Last 7 days'][:in_process][:promo] +
      @report['Last 7 days'][:in_process][:regular] -
      @report['Last 24 hours'][:in_process][:promo] -
      @report['Last 24 hours'][:in_process][:regular]
    if late_completions > 0
      subject = '[LATE] ' + subject
      ok = false
    end
    if @infusionsoft.count > 0
      subject = '[Tests Sent] ' + subject
      @infusionsoft.each do |result| # check all tags stored OK
        ok &= result[:style]
        ok &= result[:primary_style]
        ok &= result[:secondary_style]
        ok &= result[:latent_style]
      end
    end
    unless ok
      x_priority = 1 # Highest
      importance = 'High'
    end
    mail(to: ENV['IQE_COACH_EMAIL'],
         bcc: ENV['IQE_PROGRAMMER_EMAIL'],
         subject: subject,
         Importance: importance,
         'X-Priority' => x_priority
    )
  end

  def dump_qtest
    subject = 'Dump of Innovation Quotient Edge Assessments'
    ok = true
    x_priority = 3  # normal
    importance = 'Normal'
    csv_file_name = 'IQE_test_dump.csv'
    csv_string = CSV.generate do |csv|
      csv << Qtest.attribute_names
      Qtest.all.each do |result|
        csv << result.attributes.values
      end
    end
    attachments[csv_file_name] = csv_string
    mail(to: ENV['IQE_COACH_EMAIL'],
         Importance: importance,
         'X-Priority' => x_priority,
         subject: subject)
  end
end
