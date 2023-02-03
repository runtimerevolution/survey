# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :survey, class: Survey::Survey do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    survey_type { Faker::Number.within(range: 0..2) }
    active { false }
    finished { false }
    attempts_number { Faker::Number.number(digits: 2) }

    transient do
      correct { false }
      num_questions { 0 }
      options_per_question { 0 }
    end

    after(:build) do |survey, eval|
      eval.num_questions.times do
        create(:question, survey: survey,
                          correct: eval.correct,
                          num_options: eval.options_per_question)
      end
    end
  end
end
