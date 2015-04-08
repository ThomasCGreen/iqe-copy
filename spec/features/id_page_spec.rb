require 'rails_helper'

feature 'IQE Test - ID Page' do

  scenario 'No ID entries provided' do
    @qtest = FactoryGirl.create(:qtest,
                                question_finished: -1,
                                unused: true)

    visit '/taketest/' + @qtest.license_key

    expect(page).to have_text('Hello and welcome to the Innovation Quotient')

    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    fill_in 'Email', with: ''

    click_button 'Start Assessment'

    expect(page).to have_text("First name can't be blank")
    expect(page).to have_text("Last name can't be blank")
    expect(page).to have_text("Email can't be blank")
  end

  scenario 'Email not in correct format' do
    @qtest = FactoryGirl.create(:qtest,
                                question_finished: -1,
                                unused: true)

    visit '/taketest/' + @qtest.license_key

    fill_in 'First name', with: Faker::Name.first_name
    fill_in 'Last name', with: Faker::Name.last_name
    fill_in 'Email', with: Faker::Name.first_name

    click_button 'Start Assessment'

    expect(page).to have_text('Email is invalid')
  end
end
