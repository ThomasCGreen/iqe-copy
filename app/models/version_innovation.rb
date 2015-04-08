class VersionInnovation < ActiveRecord::Base
  belongs_to :version
  has_many :innovations
end
