# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_answer do
    qtest_id 1
    question 1
    question_number 1
    answer 1
  end
end
