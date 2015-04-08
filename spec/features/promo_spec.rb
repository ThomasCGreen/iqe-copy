require 'rails_helper'

feature 'Create Promo License' do

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'Incorrect Promo Entries' do

    visit '/promo/'

    expect(page).to have_text('Please provide information for the '\
                              'person receiving the promo')

    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''

    click_button 'Create Promo'

    expect(page).to have_text("First name can't be blank")
    expect(page).to have_text("Last name can't be blank")
    expect(page).to have_text("Email can't be blank")
    expect(page).to have_text('Incorrect Password')
  end

  scenario 'Promo Email not in correct format' do

    visit '/promo'

    expect(page).to have_text('Welcome to the promo license creation page.')
    expect(page).to have_text('Oops…If you are here accidentally')

    fill_in 'First name', with: Faker::Name.first_name
    fill_in 'Last name', with: Faker::Name.last_name
    fill_in 'Email', with: Faker::Name.first_name

    click_button 'Create Promo'

    expect(page).to have_text('Email is invalid')
  end

  scenario 'should Create a promo license and email it' do

    qtest = FactoryGirl.build(:qtest)

    visit '/promo'

    fill_in 'First name', with: qtest.first_name
    fill_in 'Last name', with: qtest.last_name
    fill_in 'Email', with: qtest.email
    fill_in 'Password', with: ENV['IQE_ADMIN_PASSWORD']

    click_button 'Create Promo'

    Qtest.find_by_email(qtest.email)

    expect(page).to have_text('Thank you. The unique link')
    expect(page).to have_text("#{qtest.first_name} #{qtest.last_name}: "\
                              "#{qtest.email}")

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    mail = ActionMailer::Base.deliveries.last

    expect(mail.subject).to have_text(
                              '[Your IQE Link] Test Drive Innovation '\
                              'Quotient Edge (IQE)')
    expect(mail.to).to eql([qtest.email])
    expect(mail.from).to eql(['Tamara@TheShuuk.com'])

    expect(mail.body.encoded).to have_text('You are receiving this email'\
       ' because you talked directly to Tamara')
    expect(mail.body.encoded).to have_text('Below is your unique link to '\
    'take the Innovation Quotient')
    expect(mail.body.encoded).to have_text('Perform at your peak')
    expect(mail.body.encoded).to have_text('Bring more innovative ideas to '\
    'the table')
    expect(mail.body.encoded).to have_text('Be a high-value team member')
    expect(mail.body.encoded).to have_text('Create game-changing results')
    expect(mail.body.encoded).to have_text('Have the right people, doing the '\
    'right things for high-impact results')
    expect(mail.body.encoded).to have_text('Ensure your people are bringing '\
    'more innovative thinking')
    expect(mail.body.encoded).to have_text('Empower your people to play to '\
    'their strengths')

  end
end
