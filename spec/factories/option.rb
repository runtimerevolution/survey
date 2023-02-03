# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :option, class: Survey::Option do
    question { nil }
    text { Faker::Name.name }
    weight { 0 }
    correct { false }
  end
end
