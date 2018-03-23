module ::Kernel
  def rails5?
    return defined?(Rails) && Rails::VERSION::MAJOR == 5
  end

  def rails4?
    return defined?(Rails) && Rails::VERSION::MAJOR == 4
  end

  def in_rails_3(&block)
    yield if block_given? unless rails4? || rails5?
  end
end

require 'survey/engine'
require 'survey/version'
require 'survey/active_record'

ActiveRecord::Base.send(:include, Survey::ActiveRecord)
