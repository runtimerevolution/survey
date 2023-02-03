# frozen_string_literal: true

require 'rails_helper'

describe Survey, type: :model do # rubocop:disable Metrics/BlockLength
  it 'should pass if user b was the more right answers' do
    user_a = create(:user)
    user_b = create(:user)
    survey = create(:survey, num_questions: 4, correct: true, options_per_question: 1)

    create(:attempt, survey: survey, participant: user_a, options: survey.correct_options)
    create(:attempt, survey: survey, participant: user_b, options: [])

    expect(user_a).to eq(survey.attempts.scores.first.participant)
    expect(user_b).to eq(survey.attempts.scores.last.participant)
  end

  it 'should pass if all the users has the same score' do
    user_a = create(:user)
    user_b = create(:user)
    survey = create(:survey, num_questions: 4, correct: true, options_per_question: 1)

    create(:attempt, survey: survey, participant: user_a, options: survey.correct_options)
    create(:attempt, survey: survey, participant: user_b, options: survey.correct_options)

    score_a = survey.attempts.for_participant(user_a).high_score
    score_b = survey.attempts.for_participant(user_b).high_score
    expect(score_a).to eq(score_b)
  end

  it 'should pass if user a was the winner of survey' do
    user_a = create(:user)
    user_b = create(:user)
    survey_a = create(:survey, num_questions: 4, correct: true, options_per_question: 1)
    survey_b = create(:survey, num_questions: 8, correct: true, options_per_question: 1)

    create(:attempt, survey: survey_a, participant: user_a, options: survey_a.correct_options)
    create(:attempt, survey: survey_a, participant: user_b, options: [])

    create(:attempt, survey: survey_b, participant: user_b, options: survey_b.correct_options)
    create(:attempt, survey: survey_b, participant: user_a, options: [])

    expect(user_a).to eq(survey_a.attempts.scores.first.participant)
    expect(user_b).to eq(survey_a.attempts.scores.last.participant)

    expect(user_b).to eq(survey_b.attempts.scores.first.participant)
    expect(user_a).to eq(survey_b.attempts.scores.last.participant)
  end
end
