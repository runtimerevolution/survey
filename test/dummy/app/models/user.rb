class User < ActiveRecord::Base

  has_surveys
  attr_accessible :name
end
