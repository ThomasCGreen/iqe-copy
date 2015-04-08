# controller to create promotional licenses
class PromoController < ApplicationController
  def index
    @qtest = Qtest.new(license_key: new_license)
  end

  def save
    @qtest = Qtest.new(license_key: params[:qtest][:license_key],
                       first_name: params[:qtest][:first_name],
                       last_name: params[:qtest][:last_name],
                       email: params[:qtest][:email],
                       coach_first_name: ENV['IQE_COACH_FIRST'],
                       coach_last_name: ENV['IQE_COACH_LAST'],
                       coach_email: ENV['IQE_COACH_EMAIL'],
                       send_to_client: true,
                       free_test: true,
                       major_version: 0,
                       minor_version: 0,
                       unused: true,
                       license_key_sent: false,
                       question_finished: 0)
    errors = !@qtest.valid?
    if params[:qtest][:password] != ENV['IQE_ADMIN_PASSWORD']
      @qtest.errors[:password] = 'Incorrect Password'
      errors = true
    end
    @qtest.question_finished = -1
    if errors
      render 'index'
    else
      # Have client start at first page when they take the test,
      # with question_finished = -1
      @qtest.save
      IqeMailer.promo_to_client_email(@qtest).deliver
    end
  end

  private

  def new_license
    key_in_integers = ([2**16] * 4).map { |number| rand(number) }
    key_in_hex = key_in_integers.map { |number| format('%04X', number) }
    key = key_in_hex.join('-')
    Qtest.exists?(license_key: key) ? new_license : key
  end
end
