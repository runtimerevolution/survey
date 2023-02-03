class User < ActiveRecord::Base
  validates :name, length: { maximum: 30 }, presence: true
  has_surveys
end