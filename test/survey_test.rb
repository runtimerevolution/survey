require 'test_helper'

class SurveyTest < ActiveSupport::TestCase

  test "should pass if user b was more right answers" do
    user_a = create_user
    user_b = create_user
    survey = create_survey_with_questions(4)

    create_attempt_for(user_a, survey)
    create_attempt_for(user_b, survey, all_correct: true)

    assert_not_equal user_b, participant_with_more_wrong_answers(survey)
    assert_equal user_b, participant_with_more_right_answers(survey)
  end

  test "should pass if all the users have the same score" do
    user_a = create_user
    user_b = create_sti_user
    survey = create_survey_with_questions(4)

    create_attempt_for(user_a, survey, all_correct: true)
    create_attempt_for(user_b, survey, all_correct: true)

    assert_equal participant_score(user_a, survey),
                 participant_score(user_b, survey)
  end

  test "should pass if user a was the winner of survey" do
    user_a = create_user
    user_b = create_user
    survey_a = create_survey_with_questions(4)
    survey_b = create_survey_with_questions(8)

    create_attempt_for(user_a, survey_a)
    create_attempt_for(user_b, survey_a, all_correct: true)

    create_attempt_for(user_a, survey_b, all_correct: true)
    create_attempt_for(user_b, survey_b)

    assert_equal user_a, participant_with_more_right_answers(survey_b)
    assert_equal user_b, participant_with_more_right_answers(survey_a)

    assert_equal user_a, participant_with_more_wrong_answers(survey_a)
    assert_equal user_b, participant_with_more_wrong_answers(survey_b)
  end

  test "check if the score is positive" do
    number_of_questions = 4
    number_of_options_per_question = 4
    weight_of_options = 10

    user = create_user
    survey = create_survey_with_questions_and_scores(number_of_questions, number_of_options_per_question, weight: weight_of_options)

    create_attempt_choosing_first_option(user, survey)
    
    assert (survey.attempts.first.score > 0)
    assert_equal survey.attempts.first.score, (number_of_questions * weight_of_options)
  end

end