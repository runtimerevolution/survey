# frozen_string_literal: true

require 'survey/answer'

RailsAdmin.config do |c|
  c.excluded_models = [Survey::Answer]
end
