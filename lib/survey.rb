module ::Kernel
  def rails_less_than_4?
    return defined?(Rails) && Rails::VERSION::MAJOR < 4
  end
  
  def in_rails_3(&block)
    yield if block_given? if rails_less_than_4?
  end
end

require 'survey/engine'
require 'survey/version'
require 'survey/active_record'

ActiveRecord::Base.send(:include, Survey::ActiveRecord)
