require 'rails_helper'

feature 'Unknown links' do

  scenario 'bad link' do

    visit '/promo2'

    expect(page).to have_text('You have reached an unspecified')

  end

end
