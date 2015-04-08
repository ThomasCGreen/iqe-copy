require 'rails_helper'

feature 'Top of page links' do

  scenario 'Group Test' do

    visit '/'

    click_link 'Group Assessment'

    expect(page).to have_text('Want to build a high performance team?')

  end

  scenario 'About' do

    visit '/'

    click_link 'About'

    expect(page).to have_text('is the culmination of more than 20 years')

  end

  scenario 'starts up correctly' do

    visit '/'

    click_link 'Contact Us'

    expect(page).to have_text('Do you have a few more questions?')

  end
end
