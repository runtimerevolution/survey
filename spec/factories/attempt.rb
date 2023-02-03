# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :attempt, class: Survey::Attempt do
    participant_id { nil }
    participant_type { '' }
    survey { nil }
    winner { false }
    score { 0 }

    transient do
      options { [] }
    end

    after(:build) do |attempt, eval|
      eval.options.each do |opt|
        attempt.score += 1
        create(:answer, attempt: attempt,
                        option: opt,
                        question: opt.question)
      end
    end
  end
end
