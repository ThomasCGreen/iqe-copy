require 'rails_helper'
require 'spec_helper'
require 'capybara/rails'
include QtestHelper

describe IqeMailer do
  let (:qtest) { FactoryGirl.build(:qtest) }

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe 'Mail Results' do

    it 'renders the headers' do

      (1..33).to_a.shuffle.each_with_index do |question_number, index|
        QuestionAnswer.new(qtest_id: qtest,
                           question_seq: index + 1,
                           answer: rand(6) + 1,
                           question_number: question_number).save
      end

      qtest.send_to_client = [true, false].sample
      qtest.calculate_test
      pdf = qtest.generate_pdf_report
      IqeMailer.results_email(qtest, pdf).deliver
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      mail = ActionMailer::Base.deliveries.last

      unless qtest.send_to_client
        expect(mail.subject).to have_text('NOT SENT TO CLIENT')
      end

      expect(mail.subject).to have_text('IQE Results')
      expect(mail.to).to eql([qtest.coach_email])
      expect(mail.from).to eql(['Results@InnovationQuotientTest.com'])
    end

    it 'renders the body' do

      (1..33).to_a.shuffle.each_with_index do |question_number, index|
        QuestionAnswer.new(qtest_id: qtest,
                           question_seq: index + 1,
                           answer: rand(6) + 1,
                           question_number: question_number).save
      end

      qtest.send_to_client = [true, false].sample
      qtest.calculate_test
      pdf = qtest.generate_pdf_report
      IqeMailer.results_email(qtest, pdf).deliver
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      mail = ActionMailer::Base.deliveries.last

      if qtest.send_to_client
        expect(mail.body.encoded).to have_text('These results were also sent')
      else
        expect(mail.body.encoded).to have_text('Per your request, these '\
        'results were not sent')
      end

      expect(mail.body.encoded).to have_text('First name')
      expect(mail.body.encoded).to have_text(qtest.first_name)

      expect(mail.body.encoded).to have_text('Last name')
      expect(mail.body.encoded).to have_text(qtest.last_name)

      expect(mail.body.encoded).to have_text('Email')
      expect(mail.body.encoded).to have_text(qtest.email)

      expect(mail.body.encoded).to have_text('Innovation Style:')
      expect(mail.body.encoded).to have_text(qtest.innovation_style)

      expect(mail.body.encoded).to have_text('Primary Power Trigger:')
      expect(mail.body.encoded).to have_text(qtest.driving_strength_1)

      expect(mail.body.encoded).to have_text('Secondary Power Trigger:')
      expect(mail.body.encoded).to have_text(qtest.driving_strength_2)

      expect(mail.body.encoded).to have_text('Dormant Trigger:')
      expect(mail.body.encoded).to have_text(qtest.latent_strength)

    end

    it 'renders the renders some correct results' do

      answers = { strongly_disagree: 1, disagree: 2, slightly_disagree: 3,
                  slightly_agree: 4, agree: 5, strongly_agree: 6 }

      answer_ = []
      answer_[1] = answers[:agree]
      answer_[2] = answers[:agree]
      answer_[3] = answers[:agree]

      answer_[4] = answers[:strongly_agree]
      answer_[5] = answers[:slightly_agree]
      answer_[6] = answers[:agree]

      answer_[7] = answers[:slightly_disagree]
      answer_[8] = answers[:slightly_agree]
      answer_[9] = answers[:slightly_agree]

      answer_[10] = answers[:agree]
      answer_[11] = answers[:agree]
      answer_[12] = answers[:slightly_agree]

      answer_[13] = answers[:slightly_disagree]
      answer_[14] = answers[:slightly_agree]
      answer_[15] = answers[:slightly_agree]

      answer_[16] = answers[:slightly_agree]
      answer_[17] = answers[:agree]
      answer_[18] = answers[:slightly_disagree]

      answer_[19] = answers[:disagree]
      answer_[20] = answers[:slightly_agree]
      answer_[21] = answers[:slightly_agree]

      answer_[22] = answers[:slightly_agree]
      answer_[23] = answers[:slightly_agree]
      answer_[24] = answers[:slightly_disagree]

      answer_[25] = answers[:slightly_disagree]
      answer_[26] = answers[:slightly_agree]
      answer_[27] = answers[:slightly_agree]

      answer_[28] = answers[:disagree]
      answer_[29] = answers[:agree]
      answer_[30] = answers[:disagree]

      answer_[31] = answers[:agree]
      answer_[32] = answers[:agree]
      answer_[33] = answers[:agree]

      (1..33).each_with_index do |question_number|
        QuestionAnswer.new(qtest_id: qtest,
                           question_seq: question_number,
                           answer: answer_[question_number],
                           question_number: question_number).save
      end

      qtest.state = 'Colorado'
      qtest.gender = 'Male'

      qtest.calculate_test
      pdf = qtest.generate_pdf_report
      IqeMailer.results_email(qtest, pdf).deliver
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      mail = ActionMailer::Base.deliveries.last

      expect(mail.body.encoded).to have_text('Your client has taken')

      expect(mail.body.encoded).to have_text('First name')
      expect(mail.body.encoded).to have_text(qtest.first_name)

      expect(mail.body.encoded).to have_text('Last name')
      expect(mail.body.encoded).to have_text(qtest.last_name)

      expect(mail.body.encoded).to have_text('Email')
      expect(mail.body.encoded).to have_text(qtest.email)

      expect(mail.body.encoded).to have_text('Innovation Style:')
      expect(mail.body.encoded).to have_text('Champion')

      expect(mail.body.encoded).to have_text('Primary Power Trigger:')
      expect(mail.body.encoded).to have_text('Instinctual')

      expect(mail.body.encoded).to have_text('Secondary Power Trigger:')
      expect(mail.body.encoded).to have_text('Fluid')

      expect(mail.body.encoded).to have_text('Dormant Trigger:')
      expect(mail.body.encoded).to have_text('Imaginative')

    end

    it 'renders the renders more correct results' do

      # answers = { strongly_disagree: 1, disagree: 2, slightly_disagree: 3,
      #             slightly_agree: 4, agree: 5, strongly_agree: 6 }

      answer_ = []

      answer_[1] = 2
      answer_[2] = 1
      answer_[3] = 5

      answer_[4] = 3
      answer_[5] = 2
      answer_[6] = 6

      answer_[7] = 5
      answer_[8] = 6
      answer_[9] = 1

      answer_[10] = 2
      answer_[11] = 3
      answer_[12] = 3

      answer_[13] = 3
      answer_[14] = 4
      answer_[15] = 1

      answer_[16] = 3
      answer_[17] = 3
      answer_[18] = 6

      answer_[19] = 3
      answer_[20] = 5
      answer_[21] = 1

      answer_[22] = 1
      answer_[23] = 1
      answer_[24] = 6

      answer_[25] = 3
      answer_[26] = 4
      answer_[27] = 6

      answer_[28] = 6
      answer_[29] = 6
      answer_[30] = 1

      answer_[31] = 4
      answer_[32] = 6
      answer_[33] = 3

      (1..33).each_with_index do |question_number|
        if qtest.inverted(question_number)
          answer_[question_number] = 7 - answer_[question_number]
        end
        QuestionAnswer.new(qtest_id: qtest,
                           question_seq: question_number,
                           answer: answer_[question_number],
                           question_number: question_number).save
      end

      qtest.state = 'Colorado'
      qtest.gender = 'Female'

      qtest.calculate_test
      pdf = qtest.generate_pdf_report
      IqeMailer.results_email(qtest, pdf).deliver
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      mail = ActionMailer::Base.deliveries.last

      expect(mail.body.encoded).to have_text('Your client has taken')

      expect(mail.body.encoded).to have_text('First name')
      expect(mail.body.encoded).to have_text(qtest.first_name)

      expect(mail.body.encoded).to have_text('Last name')
      expect(mail.body.encoded).to have_text(qtest.last_name)

      expect(mail.body.encoded).to have_text('Email')
      expect(mail.body.encoded).to have_text(qtest.email)

      expect(mail.body.encoded).to have_text('Innovation Style:')
      expect(mail.body.encoded).to have_text('Agent')

      expect(mail.body.encoded).to have_text('Primary Power Trigger:')
      expect(mail.body.encoded).to have_text('Inquisitive')

      expect(mail.body.encoded).to have_text('Secondary Power Trigger:')
      expect(mail.body.encoded).to have_text('Instinctual')

      expect(mail.body.encoded).to have_text('Dormant Trigger:')
      expect(mail.body.encoded).to have_text('Fluid')

    end

    it 'renders the renders other correct results' do

      # answers = { strongly_disagree: 1, disagree: 2, slightly_disagree: 3,
      #             slightly_agree: 4, agree: 5, strongly_agree: 6 }

      answer_ = []

      answer_[1] = 4
      answer_[2] = 6
      answer_[3] = 5

      answer_[4] = 2
      answer_[5] = 6
      answer_[6] = 6

      answer_[7] = 4
      answer_[8] = 3
      answer_[9] = 5

      answer_[10] = 5
      answer_[11] = 2
      answer_[12] = 5

      answer_[13] = 3
      answer_[14] = 3
      answer_[15] = 6

      answer_[16] = 5
      answer_[17] = 3
      answer_[18] = 1

      answer_[19] = 1
      answer_[20] = 6
      answer_[21] = 3

      answer_[22] = 4
      answer_[23] = 6
      answer_[24] = 4

      answer_[25] = 4
      answer_[26] = 5
      answer_[27] = 6

      answer_[28] = 5
      answer_[29] = 6
      answer_[30] = 4

      answer_[31] = 2
      answer_[32] = 5
      answer_[33] = 2

      (1..33).each do |question_number|
        # if qtest.inverted(question_number)
        #   answer_[question_number] = 7 - answer_[question_number]
        # end
        QuestionAnswer.new(qtest_id: qtest,
                           question_seq: question_number,
                           answer: answer_[question_number],
                           question_number: question_number).save
      end

      qtest.state = 'Colorado'
      qtest.gender = 'Female'

      qtest.send_to_client = true
      qtest.calculate_test
      pdf = qtest.generate_pdf_report
      IqeMailer.results_email(qtest, pdf).deliver
      IqeMailer.results_to_client_email(qtest, pdf).deliver
      expect(ActionMailer::Base.deliveries.count).to eq(2)
      mail = ActionMailer::Base.deliveries.first
      client_mail = ActionMailer::Base.deliveries.last

      expect(mail.body.encoded).to have_text('Your client has taken')

      expect(mail.body.encoded).to have_text('First name')
      expect(mail.body.encoded).to have_text(qtest.first_name)

      expect(mail.body.encoded).to have_text('Last name')
      expect(mail.body.encoded).to have_text(qtest.last_name)

      expect(mail.body.encoded).to have_text('Email')
      expect(mail.body.encoded).to have_text(qtest.email)

      expect(mail.body.encoded).to have_text('Risk Taking:')
      expect(mail.body.encoded).to have_text('14.02337')

      expect(mail.body.encoded).to have_text('Collaborative:')
      expect(mail.body.encoded).to have_text('10.0114')

      expect(mail.body.encoded).to have_text('Futuristic:')
      expect(mail.body.encoded).to have_text('11.019')

      expect(mail.body.encoded).to have_text('Imaginative:')
      expect(mail.body.encoded).to have_text('19.04704')

      expect(mail.body.encoded).to have_text('Inquisitive:')
      expect(mail.body.encoded).to have_text('19.04464')

      expect(mail.body.encoded).to have_text('Experiential:')
      expect(mail.body.encoded).to have_text('17.02926')

      expect(mail.body.encoded).to have_text('Tweaker:')
      expect(mail.body.encoded).to have_text('17.03212')

      expect(mail.body.encoded).to have_text('Fluid:')
      expect(mail.body.encoded).to have_text('9.00322')

      expect(mail.body.encoded).to have_text('Instinctual:')
      expect(mail.body.encoded).to have_text('24.09454')

      expect(mail.body.encoded).to have_text('Innovation Style:')
      expect(mail.body.encoded).to have_text('Agent')

      expect(mail.body.encoded).to have_text('Primary Power Trigger:')
      expect(mail.body.encoded).to have_text('Instinctual')

      expect(mail.body.encoded).to have_text('Secondary Power Trigger:')
      expect(mail.body.encoded).to have_text('Imaginative')

      expect(mail.body.encoded).to have_text('Dormant Trigger:')
      expect(mail.body.encoded).to have_text('Fluid')

      expect(client_mail.body.encoded).to have_text('Congratulations, you '\
      'are one click away from discovering your unique innovation style')

    end

  end

end
