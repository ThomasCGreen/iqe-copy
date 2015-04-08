# controller for taking the test
class ReportController < ApplicationController
  include QtestHelper

  def index
    if params[:password] == ENV['IQE_REPORT_PASSWORD']
      @report, @infusionsoft = ReportController.do_report
    else
      redirect_to invalid_password_path
    end
  end

  def self.do_report
    now = Time.new
    start_of_year = Time.new(now.year)
    start_of_month = Time.new(now.year, now.month)
    last_7_days = now - 7 * 24 * 60 * 60
    last_24_hours = now - 24 * 60 * 60
    last_2_hours = now - 2 * 60 * 60

    @report = { 'Last 2 hours' => { time: last_2_hours },
                'Last 24 hours' => { time: last_24_hours },
                'Last 7 days' => { time: last_7_days },
                'Since start of month' => { time: start_of_month },
                'Since start of year' => { time: start_of_year }
    }
    @report.each_key do |key|  # initialize report values
      @report[key][:count] = { regular: 0, promo: 0 }
      @report[key][:in_process] = { regular: 0, promo: 0 }
      @report[key][:finished] = { regular: 0, promo: 0 }
      @report[key][:not_finished] = { regular: [], promo: [] }
    end

    @infusionsoft = []

    qtests = Qtest.where('question_finished > -1 AND updated_at > ?',
                         start_of_year)  # started tests

    qtests.each do |qtest|

      finished = (qtest.question_finished > qtest.question_count)
      if finished
        end_time = qtest.completed_time
      else
        end_time = qtest.updated_at
      end
      if qtest.free_test
        promo = :promo
      else
        promo = :regular
      end
      @report.each_key do |key|
        next unless end_time > @report[key][:time]
        @report[key][:count][promo] += 1
        if finished
          @report[key][:finished][promo] += 1
        else
          @report[key][:in_process][promo] += 1
          @report[key][:not_finished][promo] << qtest
        end
      end
      next if qtest.results_sent_to_infusionsoft
      next unless finished
      contact_data = { 'FirstName' => qtest.first_name,
                       'LastName' => qtest.last_name,
                       'Email' => qtest.email }
      reply = Infusionsoft.contact_add_with_dup_check(contact_data, 'Email')
      sleep(1.0)
      style_tag = qtest.innovation_tag[qtest.innovation_style]

      style = Infusionsoft.contact_add_to_group(reply, style_tag)
      sleep(1.0)
      primary_strength_tag = qtest.trigger_tag(qtest.driving_strength_1,
                                               'PS_tag')
      ps = Infusionsoft.contact_add_to_group(reply, primary_strength_tag)
      sleep(1.0)
      secondary_strength_tag = qtest.trigger_tag(qtest.driving_strength_2,
                                                 'SS_tag')
      ss = Infusionsoft.contact_add_to_group(reply, secondary_strength_tag)
      sleep(1.0)
      latent_strength_tag = qtest.trigger_tag(qtest.latent_strength,
                                              'LS_tag')
      ls = Infusionsoft.contact_add_to_group(reply, latent_strength_tag)
      sleep(1.0)
      opt_in = Infusionsoft.email_get_opt_status(qtest.email)
      if opt_in == 0
        sleep(1.0)
        Infusionsoft.email_optin(qtest.email, 'Took IQE test')
      end

      qtest.results_sent_to_infusionsoft = true
      qtest.save

      @infusionsoft << { qtest: qtest,
                         style: style,
                         primary_strength: ps,
                         secondary_strength: ss,
                         latent_strength: ls
      }
    end
    IqeMailer.send_report(@report, @infusionsoft).deliver
    return @report, @infusionsoft
  end

  def invalid_password
  end
end
