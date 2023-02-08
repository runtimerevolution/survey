# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :question, class: Survey::Question do
    survey { nil }
    text { Faker::Name.name }

    transient do
      num_options { 0 }
      correct { false }
    end

    after(:build) do |question, eval|
      eval.num_options.times { create(:option, question: question, correct: eval.correct) }
    end
  end
end
