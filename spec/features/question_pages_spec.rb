require 'rails_helper'
include QtestHelper

def common_to_pages
  qtest = FactoryGirl.create(:qtest,
                             send_to_client: [true, false].sample,
                             free_test: [true, false].sample,
                             question_finished: -1,
                             unused: true)
  visit '/taketest/' + qtest.license_key
  fill_in 'First name', with: Faker::Name.first_name
  fill_in 'Last name', with: Faker::Name.last_name
  fill_in 'Email', with: Faker::Internet.email
  click_button 'Start Assessment'
  Qtest.find_by_license_key(qtest.license_key)
end

def run_through_pages(qtest, number_of_pages)
  (number_of_pages).times do
    first = qtest.question_start
    last = qtest.question_end
    (first..last).each do | question |
      random_selection = rand(6) + 1
      choose("qtest_question_answers_attributes_#{question -
        first}_answer_#{random_selection}")
    end
    click_button 'Continue'
    qtest = Qtest.find_by_license_key(qtest.license_key)
  end
end

feature 'Question Pages Text' do

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  qtest_temp = FactoryGirl.build(:qtest)

  (1..qtest_temp.total_pages).each do | page_number |

    scenario "Page #{page_number}" do

      qtest = common_to_pages
      run_through_pages(qtest, page_number - 1)

      qtest = Qtest.find_by_license_key(qtest.license_key)
      first = qtest.question_start
      last = qtest.question_end
      (first..last).each do | question |
        expect(page).to have_text(qtest.question_text(question))
      end
    end

    scenario "Page #{page_number} - no selections" do

      qtest = common_to_pages
      run_through_pages(qtest, page_number - 1)

      click_button 'Continue'

      qtest = Qtest.find_by_license_key(qtest.license_key)
      first = qtest.question_start
      last = qtest.question_end

      (first..last).each do | question |
        expect(page).to have_text("Answer #{question} can't be blank")
      end
    end

    scenario "Page #{page_number} - one selection" do

      qtest = common_to_pages
      run_through_pages(qtest, page_number - 1)

      qtest = Qtest.find_by_license_key(qtest.license_key)
      first = qtest.question_start
      last = qtest.question_end

      question_selection = rand(last - first + 1)
      random_selection = rand(6) + 1

      choose("qtest_question_answers_attributes_#{question_selection
      }_answer_#{random_selection}")

      click_button 'Continue'

      qtest = Qtest.find_by_license_key(qtest.license_key)
      first = qtest.question_start
      last = qtest.question_end

      (first..last).each do | question |
        if (question_selection + first) == question
          expect(page).not_to have_text("Answer #{question} "\
                                        "can't be blank")
        else
          expect(page).to have_text("Answer #{question} can't be blank")
        end
      end
    end

    scenario "Page #{page_number} - select random answers" do

      qtest = common_to_pages

      run_through_pages(qtest, page_number - 1)

      qtest = Qtest.find_by_license_key(qtest.license_key)
      first = qtest.question_start
      last = qtest.question_end

      (first..last).each do | question |
        expect(page).to have_text(qtest.question_text(question))
      end
    end
  end
end

feature 'Post-Questions' do
  scenario 'Questions Presented' do

    qtest = common_to_pages
    run_through_pages(qtest, qtest.total_pages)

    expect(page).to have_text('You have completed the Innovation Quotient '\
                              'Edge (IQE) assessment!')
    expect(page).to have_text('As we tabulate your results and throw some')
    expect(page).to have_text('Please take a few seconds to fill out the')
    expect(page).to have_text('‘CALCULATE MY IQE’ below')
    expect(page).to have_text('State')
    expect(page).to have_text('Department')
    expect(page).to have_text('Level')
    expect(page).to have_text('Years in workforce')
    expect(page).to have_text('Degree')
    expect(page).to have_text('Gender')
    expect(page).to have_text('Age range')
    expect(page).to have_button('Calculate My IQE!')

    click_button 'Calculate My IQE!'

    if qtest.free_test

      expect(page).to have_text('Thank you for taking the Innovation')

    elsif qtest.send_to_client

      expect(page).to have_text('Woot woot…your results are being')
      expect(page).to have_text('Know someone or a group that would find value')
      expect(page).to have_link('http://InnovationQuotientTest.com')

    else

      expect(page).to have_text('Your results are being calculated and '\
      'sent over to your coach')

    end
  end
end

feature 'Reporting of Assessments Taking' do

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'Wrong password' do

    visit '/report/123'

    expect(page).to have_text('Password specified was incorrect.')

  end

  scenario 'Report gives data' do

    qtest = common_to_pages
    run_through_pages(qtest, qtest.total_pages)
    click_button 'Calculate My IQE!'

    password = ENV['IQE_REPORT_PASSWORD']
    visit '/report/' + password

    expect(page).to have_text('The current time is:')
    expect(page).to have_text('Since start of year:')
    expect(page).to have_text('Since start of month:')
    expect(page).to have_text('Last 7 days:')
    expect(page).to have_text('Last 24 hours:')
    expect(page).to have_text('Last 2 hours:')

    expect(ActionMailer::Base.deliveries.count).to be >= 2
    tamara_mail = ActionMailer::Base.deliveries.last

    expect(tamara_mail.subject).to have_text('IQE Report')
    expect(tamara_mail.to).to have_text(ENV['IQE_COACH_EMAIL'])

    expect(tamara_mail.body.encoded).to have_text('The current time is:')
    expect(tamara_mail.body.encoded).to have_text('Since start of year:')
    expect(tamara_mail.body.encoded).to have_text('Since start of month:')
    expect(tamara_mail.body.encoded).to have_text('Last 7 days:')
    expect(tamara_mail.body.encoded).to have_text('Last 24 hours:')
    expect(tamara_mail.body.encoded).to have_text('Last 2 hours:')

  end
end
