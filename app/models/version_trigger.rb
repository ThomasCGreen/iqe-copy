class VersionTrigger < ActiveRecord::Base
  belongs_to :version
  has_many :triggers
end
