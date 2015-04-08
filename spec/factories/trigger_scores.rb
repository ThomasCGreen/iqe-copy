# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trigger_score do
    qtest_id 1
    trigger_name 'MyString'
    score 0.0

  end
end
