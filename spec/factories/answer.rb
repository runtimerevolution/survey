# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :answer, class: Survey::Answer do
    attempt { nil }
    question { nil }
    option { nil }
    correct { false }
  end
end
