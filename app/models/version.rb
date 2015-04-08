class Version < ActiveRecord::Base
  has_many :version_questions
  has_many :version_triggers
  has_many :version_innovations
  has_many :weights
end
