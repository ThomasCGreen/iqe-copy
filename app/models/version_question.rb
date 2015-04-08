class VersionQuestion < ActiveRecord::Base
  belongs_to :version
  has_many :questions
end
