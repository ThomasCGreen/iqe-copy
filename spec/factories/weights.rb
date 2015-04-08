# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weight do
    version_id 1
    question_number 1
    trigger_name 'MyString'
    normal_weight 1
    double_weight 1
  end
end
