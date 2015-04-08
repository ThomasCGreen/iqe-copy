require 'rails_helper'

feature 'Receive Code' do

  scenario 'Code not in database' do

    visit '/taketest/zzyxx'

    expect(page).to have_text('The license key provided is not valid. '\
                               'Please check your link and try again.')
  end

  scenario 'Good code provided, assessment not started yet' do
    @qtest = FactoryGirl.create(:qtest,
                                license_key: '2A5D',
                                question_finished: -1,
                                unused: true)

    visit '/taketest/' + @qtest.license_key

    expect(page).to have_text('Welcome to the Innovation Quotient Edge '\
    'Assessment!')
    expect(page).to have_text('First name')
    expect(page).to have_text('Last name')
    expect(page).to have_text('Email')
  end
end
