# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    number 1
    words 'MyString'
    inverted false
  end
end
