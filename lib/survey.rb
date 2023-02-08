# frozen_string_literal: true

# module ::Kernel
module ::Kernel
  def rails4?
    defined?(Rails) && Rails::VERSION::MAJOR == 4
  end
end

require 'survey/engine'
require 'survey/version'
require 'survey/active_record'

if defined?(ApplicationRecord)
  ApplicationRecord.include Survey::ActiveRecord
elsif defined?(ActiveRecord::Base)
  ActiveRecord::Base.include Survey::ActiveRecord
end
