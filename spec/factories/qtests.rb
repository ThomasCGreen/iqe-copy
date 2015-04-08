# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :qtest do
    license_key Faker::Number.number(16)
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    state Faker::Address.state_abbr
    gender 'M'
    age_range 'MyString'
    department Faker::Commerce.department
    level 'MyString'
    degree 'MyString'
    years_in_workforce Faker::Number.number(1)
    innovation_style 'MyString'
    driving_strength_1 'MyString'
    driving_strength_2 'MyString'
    latent_strength 'MyString'
    unused true
    license_key_sent false
    question_finished (-1)
    results_sent_to_infusionsoft false
    major_version 0
    minor_version 0
    free_test false
    coach_first_name Faker::Name.first_name
    coach_last_name Faker::Name.last_name
    coach_email Faker::Internet.email
    company Faker::Company.name
  end
end
