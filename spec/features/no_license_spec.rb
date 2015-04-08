require 'rails_helper'

feature 'No License Specified' do

  scenario 'blank taketest' do

    visit '/taketest'

    expect(page).to have_text('Hello and welcome to the Innovation Quotient')
    expect(page).to have_text('Please enter your license key below')

  end

  scenario 'incorrect license specified' do

    visit '/taketest'

    expect(page).to have_text('Hello and welcome to the Innovation Quotient')
    expect(page).to have_text('Please enter your license key below')

    fill_in 'License key', with: 'junk'

    click_button 'Start Assessment'

    expect(page).to have_text('The license key provided is not valid.')
  end

  scenario 'starts up correctly' do
    @qtest = FactoryGirl.create(:qtest,
                                license_key: 'something_good',
                                question_finished: -1,
                                unused: true)

    visit '/taketest'

    expect(page).to have_text('Hello and welcome to the Innovation Quotient')
    expect(page).to have_text('Please enter your license key below')

    fill_in 'License key', with: 'something_good'

    click_button 'Start Assessment'

    expect(page).to have_text('First name')
  end
end
