require 'rails_helper'

feature 'Create Regular Licenses' do

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'Incorrect Create Entries' do

    visit '/create'

    expect(page).to have_text('Please enter the following information for '\
                              'creating a number of new licenses.')

    fill_in 'Coach first name', with: ''
    fill_in 'Coach last name', with: ''
    fill_in 'Coach email', with: ''
    fill_in 'License quantity', with: ''
    fill_in 'Password', with: ''

    click_button 'Create Licenses'

    expect(page).to have_text("Coach first name can't be blank")
    expect(page).to have_text("Coach last name can't be blank")
    expect(page).to have_text("Coach email can't be blank")
    expect(page).to have_text('License quantity must be greater than 0')
    expect(page).to have_text('Incorrect Password')
  end

  scenario 'Create Email not in correct format' do

    visit '/create'

    fill_in 'Coach first name', with: Faker::Name.first_name
    fill_in 'Coach last name', with: Faker::Name.last_name
    fill_in 'Coach email', with: Faker::Name.first_name
    fill_in 'License quantity', with: rand(9) + 1

    click_button 'Create Licenses'

    expect(page).to have_text('Coach email is invalid')
  end

  scenario 'Should Create licenses and email to coach' do

    qtest = FactoryGirl.build(:qtest)

    visit '/create'

    # first = ENV['IQE_COACH_FIRST']
    # last = ENV['IQE_COACH_LAST']
    email = ENV['IQE_COACH_EMAIL']

    quantity = rand(9) + 1
    fill_in 'Coach first name', with: qtest.first_name
    fill_in 'Coach last name', with: qtest.last_name
    fill_in 'Coach email', with: qtest.email
    fill_in 'License quantity', with: quantity
    fill_in 'Password', with: ENV['IQE_ADMIN_PASSWORD']

    send_to_client = [true, false].sample
    uncheck 'Send to client' unless send_to_client

    click_button 'Create Licenses'

    qtest2 = Qtest.last

    expect(page).to have_text("Here are your #{quantity} licenses:")
    expect(page).to have_text('An email of these licenses has been sent to')
    expect(page).to have_text(qtest.first_name)
    expect(page).to have_text(qtest.last_name)
    expect(page).to have_text(qtest.email)

    expect(qtest2.coach_first_name).to eq(qtest.first_name)
    expect(qtest2.coach_last_name).to eq(qtest.last_name)
    expect(qtest2.coach_email).to eq(qtest.email)

    expect(ActionMailer::Base.deliveries.count).to eq(2)
    coach_mail = ActionMailer::Base.deliveries.first
    iqe_mail = ActionMailer::Base.deliveries.last

    expect(coach_mail.to).to have_text(qtest.email)
    expect(coach_mail.body.encoded).to have_text(
                                         "Dear #{qtest.first_name},")
    expect(coach_mail.body.encoded).to have_text("your #{quantity} licenses:")
    expect(coach_mail.body.encoded).to have_text(qtest2.license_key)
    if send_to_client
      expect(coach_mail.body.encoded).to have_text('All')
    else
      expect(coach_mail.body.encoded).to have_text('None')
    end

    expect(iqe_mail).to have_text(email)
    expect(iqe_mail.body.encoded).to have_text("We emailed #{quantity}")
    expect(iqe_mail.body.encoded).to have_text(qtest.first_name)
    expect(iqe_mail.body.encoded).to have_text(qtest.last_name)
    expect(iqe_mail.body.encoded).to have_text(qtest.email)
    if send_to_client
      expect(iqe_mail.body.encoded).to have_text('ALL')
    else
      expect(iqe_mail.body.encoded).to have_text('NONE')
    end

  end

  scenario 'Should Create licenses and email to default' do

    visit '/create'

    first = ENV['IQE_COACH_FIRST']
    last = ENV['IQE_COACH_LAST']
    email = ENV['IQE_COACH_EMAIL']

    quantity = rand(9) + 1
    fill_in 'License quantity', with: quantity
    fill_in 'Password', with: ENV['IQE_ADMIN_PASSWORD']

    send_to_client = [true, false].sample
    uncheck 'Send to client' unless send_to_client

    click_button 'Create Licenses'

    qtest2 = Qtest.last

    expect(page).to have_text("Here are your #{quantity} licenses:")
    expect(page).to have_text('An email of these licenses has been sent to')
    expect(page).to have_text(first)
    expect(page).to have_text(last)
    expect(page).to have_text(email)

    expect(qtest2.coach_first_name).to eq(first)
    expect(qtest2.coach_last_name).to eq(last)
    expect(qtest2.coach_email).to eq(email)

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    coach_mail = ActionMailer::Base.deliveries.first

    expect(coach_mail.to).to have_text(email)
    expect(coach_mail.body.encoded).to have_text("Dear #{first},")
    expect(coach_mail.body.encoded).to have_text("your #{quantity} licenses:")
    expect(coach_mail.body.encoded).to have_text(qtest2.license_key)
    if send_to_client
      expect(coach_mail.body.encoded).to have_text('All')
    else
      expect(coach_mail.body.encoded).to have_text('None')
    end

  end

  scenario 'Should Create multiuse license and email to coach' do

    qtest = FactoryGirl.build(:qtest)

    visit '/create'

    # first = ENV['IQE_COACH_FIRST']
    # last = ENV['IQE_COACH_LAST']
    email = ENV['IQE_COACH_EMAIL']

    quantity = rand(9) + 1
    fill_in 'Coach first name', with: qtest.first_name
    fill_in 'Coach last name', with: qtest.last_name
    fill_in 'Coach email', with: qtest.email
    fill_in 'License quantity', with: quantity
    fill_in 'Company', with: qtest.company
    fill_in 'Password', with: ENV['IQE_ADMIN_PASSWORD']

    send_to_client = [true, false].sample
    uncheck 'Send to client' unless send_to_client

    check 'Multi license'

    click_button 'Create Licenses'

    qtest2 = Qtest.last

    expect(page).to have_text("Here is your multi-use license with #{quantity}"\
    ' uses:')
    expect(page).to have_text('An email of this license has been sent to')
    expect(page).to have_text(qtest.first_name)
    expect(page).to have_text(qtest.last_name)
    expect(page).to have_text(qtest.email)

    expect(qtest2.coach_first_name).to eq(qtest.first_name)
    expect(qtest2.coach_last_name).to eq(qtest.last_name)
    expect(qtest2.coach_email).to eq(qtest.email)
    expect(qtest2.multi_license).to eq(quantity)

    expect(ActionMailer::Base.deliveries.count).to eq(2)
    coach_mail = ActionMailer::Base.deliveries.first
    iqe_mail = ActionMailer::Base.deliveries.last

    expect(coach_mail.to).to have_text(qtest.email)
    expect(coach_mail.body.encoded).to have_text(
                                         "Dear #{qtest.first_name},")
    expect(coach_mail.body.encoded).to have_text('Here is your unique multi-'\
    "license with #{quantity} uses:")
    expect(coach_mail.body.encoded).to have_text('Please note that the above'\
     ' link is valid for ')
    expect(coach_mail.body.encoded).to have_text(qtest2.license_key)
    if send_to_client
      expect(coach_mail.body.encoded).to have_text('All')
    else
      expect(coach_mail.body.encoded).to have_text('None')
    end

    expect(iqe_mail).to have_text(email)
    expect(iqe_mail.body.encoded).to have_text('We emailed a multi-use license'\
    " with #{quantity} uses")
    expect(iqe_mail.body.encoded).to have_text(qtest.first_name)
    expect(iqe_mail.body.encoded).to have_text(qtest.last_name)
    expect(iqe_mail.body.encoded).to have_text(qtest.email)
    if send_to_client
      expect(iqe_mail.body.encoded).to have_text('ALL')
    else
      expect(iqe_mail.body.encoded).to have_text('NONE')
    end

  end

  scenario 'Should Create multiuse license and email to default' do

    visit '/create'

    first = ENV['IQE_COACH_FIRST']
    last = ENV['IQE_COACH_LAST']
    email = ENV['IQE_COACH_EMAIL']

    quantity = rand(9) + 1
    fill_in 'License quantity', with: quantity
    fill_in 'Password', with: ENV['IQE_ADMIN_PASSWORD']

    send_to_client = [true, false].sample
    uncheck 'Send to client' unless send_to_client

    check 'Multi license'

    click_button 'Create Licenses'

    qtest2 = Qtest.last

    expect(page).to have_text("Here is your multi-use license with #{quantity}"\
    ' uses:')
    expect(page).to have_text('An email of this license has been sent to')
    expect(page).to have_text(first)
    expect(page).to have_text(last)
    expect(page).to have_text(email)

    expect(qtest2.coach_first_name).to eq(first)
    expect(qtest2.coach_last_name).to eq(last)
    expect(qtest2.coach_email).to eq(email)
    expect(qtest2.multi_license).to eq(quantity)

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    coach_mail = ActionMailer::Base.deliveries.first

    expect(coach_mail.to).to have_text(email)
    expect(coach_mail.body.encoded).to have_text("Dear #{first},")
    expect(coach_mail.body.encoded).to have_text('Here is your unique multi-'\
    "license with #{quantity} uses:")
    expect(coach_mail.body.encoded).to have_text(qtest2.license_key)
    if send_to_client
      expect(coach_mail.body.encoded).to have_text('All')
    else
      expect(coach_mail.body.encoded).to have_text('None')
    end

  end
end
