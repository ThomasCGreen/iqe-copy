# class for verifing qtest tables
class Qtest < ActiveRecord::Base
  include QtestHelper
  has_many :trigger_scores
  has_many :question_answers
  accepts_nested_attributes_for :question_answers

  with_options if: :page_0_completed? do |id_page|
    id_page.validates_presence_of :first_name
    id_page.validates_presence_of :last_name
    id_page.validates_presence_of :email
    id_page.validates_format_of :email,
                                with:
                                  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  with_options if: :create_test? do |create|
    create.validates_presence_of :coach_first_name
    create.validates_presence_of :coach_last_name
    create.validates_presence_of :coach_email
    create.validates_format_of :coach_email,
                               with:
                                 /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  with_options if: :questions_section? do
    validates_with QtestValidator
  end

  def page_0_completed?
    question_finished >= 0
  end

  def create_test?
    question_finished == -2
  end

  def questions_section?
    question_finished >= 1
  end

  def email_addr
    /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
