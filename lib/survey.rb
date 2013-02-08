require 'survey/engine'
require 'survey/version'
require 'survey/active_record'

ActiveRecord::Base.send(:include, Survey::ActiveRecord)