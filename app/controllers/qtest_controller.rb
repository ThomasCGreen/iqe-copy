# controller for taking the test
class QtestController < ApplicationController
  include QtestHelper

  def index
    @license_key = params[:license_key]
    @qtest = Qtest.find_by_license_key(@license_key)
    redirect_to invalid_license_path unless @qtest
    return unless @qtest
    return unless @qtest.question_finished == -1
    return unless @qtest.multi_license
    return unless @qtest.multi_license < 1
    redirect_to multi_license_finished_path
  end

  def save
    @license_key = params[:license_key]
    @qtest = Qtest.find_by_license_key(@license_key)
    redirect_to invalid_license_path unless @qtest

    if params[:commit] == 'Re-email'
      pdf = @qtest.generate_pdf_report
      IqeMailer.results_to_client_email(@qtest, pdf).deliver
    elsif params[:commit] == '<-- Go Back '
      @qtest.move_backward
      @qtest.save
    elsif @qtest.question_finished == @qtest.question_count
      @qtest.state = params[:qtest][:state]
      @qtest.department = params[:qtest][:department]
      @qtest.level = params[:qtest][:level]
      @qtest.years_in_workforce = params[:qtest][:years_in_workforce]
      @qtest.degree = params[:qtest][:degree]
      @qtest.gender = params[:qtest][:gender]
      @qtest.age_range = params[:qtest][:age_range]
      @qtest.calculate_test
      @qtest.move_forward
      @qtest.completed_time = Time.now
      @qtest.save
      pdf = @qtest.generate_pdf_report
      IqeMailer.results_email(@qtest, pdf).deliver
      if @qtest.send_to_client
        IqeMailer.results_to_client_email(@qtest, pdf).deliver
      end
      # @qtest.send_to_infusionsoft
    elsif @qtest.question_finished >= 0
      (0..(@qtest.question_end - @qtest.question_start)).each do |q|
        ans = params[:qtest][:question_answers_attributes][q.to_s]
        next unless ans.key?('answer')
        qa = QuestionAnswer.find(ans[:id])
        qa[:answer] = ans[:answer].to_i
        qa.save
      end
      @qtest.move_forward
      @qtest.move_backward unless @qtest.save
      render 'index'
    elsif @qtest.question_finished == -1
      params.require(:qtest).permit(:first_name, :last_name, :email)
      if @qtest.multi_license
        redirect_to multi_license_finished_path unless @qtest.multi_license >= 1
        @qtest2 = @qtest.clone
        @qtest.multi_license -= 1
        @qtest.save
        @qtest = @qtest2.dup
        @qtest.multi_license = nil  # make this one a normal license
        @qtest.license_key = new_license  # create a key for the new license
        # params[:license_key] = @qtest.license_key
      end
      @qtest.first_name = params[:qtest][:first_name]
      @qtest.last_name = params[:qtest][:last_name]
      @qtest.email = params[:qtest][:email]
      @qtest.save
      if @qtest.unused
        @qtest.unused = false
        (1..@qtest.question_count).to_a.shuffle
        .each_with_index do |question_number, index|
          QuestionAnswer.new(qtest_id: @qtest.id,
                             question_seq: index + 1,
                             question_number: question_number).save
        end
      end
      @qtest.move_forward
      if @qtest.save
        redirect_to qtest_path(@qtest.license_key)
      else
        @qtest.move_backward
      end

    end
  end

  def invalid
  end

  def multi_license_finished
  end

  private

  def new_license
    key_in_integers = ([2**16] * 6).map { |number| rand(number) }
    key_in_hex = key_in_integers.map { |number| format('%04X', number) }
    key = key_in_hex.join('-')
    Qtest.exists?(license_key: key) ? new_license : key
  end
end
