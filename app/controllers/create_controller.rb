# controller for creating license keys
class CreateController < ApplicationController
  def index
    @qtest = Qtest.new(coach_first_name: ENV['IQE_COACH_FIRST'],
                       coach_last_name: ENV['IQE_COACH_LAST'],
                       coach_email: ENV['IQE_COACH_EMAIL'],
                       send_to_client: true)
  end

  def save
    @coach_first_name = params[:qtest][:coach_first_name]
    @coach_last_name = params[:qtest][:coach_last_name]
    @coach_email = params[:qtest][:coach_email]
    @company = params[:qtest][:company]
    @license_quantity = params[:qtest][:license_quantity].to_i
    @multiuse_license = (params[:qtest][:multi_license] == '1')
    @send_to_client = (params[:qtest][:send_to_client] == '1')
    @qtest = Qtest.new(coach_first_name: @coach_first_name,
                       coach_last_name: @coach_last_name,
                       coach_email: @coach_email,
                       question_finished: -2)
    errors = !@qtest.valid?
    if params[:qtest][:password] != ENV['IQE_ADMIN_PASSWORD']
      @qtest.errors[:password] = 'Incorrect Password'
      errors = true
    end
    if @license_quantity <= 0
      @qtest.errors[:license_quantity] = 'must be greater than 0'
      errors = true
    end
    if errors
      render 'index'
    else
      if @multiuse_license
        @licenses = [new_license]
        qtest = Qtest.new(license_key: @licenses[0],
                          coach_first_name: @coach_first_name,
                          coach_last_name: @coach_last_name,
                          coach_email: @coach_email,
                          send_to_client: @send_to_client,
                          major_version: 0,
                          minor_version: 0,
                          question_finished: -1,
                          multi_license: @license_quantity,
                          company: @company,
                          unused: true,
                          license_key_sent: false)
        qtest.save
      else
        @licenses = []
        @license_quantity.times do
          @licenses << (license = new_license)
          qtest = Qtest.new(license_key: license,
                            coach_first_name: @coach_first_name,
                            coach_last_name: @coach_last_name,
                            coach_email: @coach_email,
                            send_to_client: @send_to_client,
                            major_version: 0,
                            minor_version: 0,
                            question_finished: -1,
                            multi_license: nil,
                            company: @company,
                            unused: true,
                            completed_time: nil,
                            license_key_sent: false)
          qtest.save
        end
      end
      IqeMailer.create_licenses_to_coach_email(@license_quantity,
                                               @licenses,
                                               @send_to_client,
                                               @multiuse_license,
                                               @coach_first_name,
                                               @coach_last_name,
                                               @coach_email).deliver
      if @coach_email != ENV['IQE_COACH_EMAIL']
        IqeMailer.create_licenses_email(@license_quantity,
                                        @licenses,
                                        @send_to_client,
                                        @multiuse_license,
                                        @coach_first_name,
                                        @coach_last_name,
                                        @coach_email).deliver
      end
    end
  end

  private

  def new_license
    key_in_integers = ([2**16] * 6).map { |number| rand(number) }
    key_in_hex = key_in_integers.map { |number| format('%04X', number) }
    key = key_in_hex.join('-')
    Qtest.exists?(license_key: key) ? new_license : key
  end
end
