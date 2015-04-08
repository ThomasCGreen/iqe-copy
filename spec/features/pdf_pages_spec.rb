require 'rails_helper'
include QtestHelper

def common_to_pdf_pages
  qtest = FactoryGirl.create(:qtest,
                             license_key: '2A5D',
                             question_finished: -1,
                             unused: true)
  qtest.load_db

  [4, 6, 5, 2, 6, 6, 4, 3, 5, 5, 2, 5, 3, 3, 6, 5, 3, 1, 1, 6, 3, 4, 6, 4, 4,
   5, 6, 5, 6, 4, 2, 5, 2].each_with_index do |answer, question|
    QuestionAnswer.new(qtest_id: qtest.id,
                       question_number: question + 1,
                       answer: answer,
                       question_seq: question + 1).save
  end

  # answers = { strongly_disagree: 1, disagree: 2, slightly_disagree: 3,
  #             slightly_agree: 4, agree: 5, strongly_agree: 6 }

  qtest.state = 'Colorado'
  qtest.gender = 'Female'

  qtest.calculate_test
  qtest
end

feature 'pdf Pages' do

  scenario 'Cover Page of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(1).to_s

    expect(pdf_page).to include("#{qtest.first_name}")
    expect(pdf_page).to include("#{qtest.last_name}")
    expect(pdf_page).to include('Innovation Quotient')
    expect(pdf_page).to include('Report')

  end

  scenario 'Page 1 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(2).to_s

    expect(pdf_page).to include('The IQE is your opportunity to discover your')

  end

  scenario 'Page 2 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(3).to_s

    expect(pdf_page).to include(qtest.first_name + "'s")
    expect(pdf_page).to include(qtest.first_name)
    expect(pdf_page).to include(qtest.innovation_style)

  end

  scenario 'Page 3 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(4).to_s

    expect(pdf_page).to include('YOU, AT YOUR PEAK:')

    expect(pdf_page).to include(qtest.trigger_hash[qtest.driving_strength_1][
                                  'You at your peak'][1][0..20])
    expect(pdf_page).to include(qtest.strength_and_style(
                                  qtest.driving_strength_1)[0])
    expect(pdf_page).to include(qtest.strength_and_style(
                                  qtest.driving_strength_1)[1])
    # expect(pdf_page).to include(qtest.strength_and_style(
    #                               qtest.driving_strength_2)[0])
    expect(pdf_page).to include(qtest.strength_and_style(
                                  qtest.driving_strength_2)[1])

  end

  scenario 'Page 4 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(5).to_s

    expect(pdf_page).to include('HOW YOU ADD VALUE:')

  end

  scenario 'Page 5 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    PDF::Reader.new(StringIO.new(pdf.render)).page(6).to_s

  end

  scenario 'Page 6 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(7).to_s

    expect(pdf_page).to include("#{qtest.first_name}'s Action Plan")
    expect(pdf_page).to include('Being You, At Your Peak:')
    expect(pdf_page).to include('(The situations where you thrive)')
    expect(pdf_page).to include(qtest.trigger_hash[qtest.driving_strength_2][
                                  'Action step'][1][57..75])

    expect(pdf_page).to include('(Tools & templates to exercise your')

    expect(pdf_page).to include(qtest.trigger_hash[qtest.driving_strength_1][
                                  'Exercise'][1])
    expect(pdf_page).to include(qtest.trigger_hash[qtest.driving_strength_2][
                                  'Exercise'][0])
    expect(pdf_page).to include(qtest.trigger_hash[qtest.driving_strength_2][
                                  'Exercise'][1])

  end
  scenario 'Page 7 of pdf' do

    qtest = common_to_pdf_pages
    pdf = qtest.generate_pdf_report

    pdf_page = PDF::Reader.new(StringIO.new(pdf.render)).page(8).to_s

    expect(pdf_page).to include("#{qtest.first_name} #{qtest.last_name}'s "\
                                'Scores')

  end

end
