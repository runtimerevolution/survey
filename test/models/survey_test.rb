class SurveyTest < ActiveSupport::TestCase

  test "should not create a valid survey without sections" do
    survey = create_survey
    should_not_be_persisted survey
  end

  test "should not create a  survey with active flag true and empty questions collection" do
    surveyA = create_survey({:active => true})
    surveyB = create_survey_with_sections(2)
    surveyB.active = true
    surveyB.save

    should_not_be_persisted surveyA
    should_be_persisted surveyB
    should_be_true surveyB.valid?
  end

  test "should create a survey with 3 sections" do
    num_questions = 3
    survey = create_survey_with_sections(num_questions, num_questions)
    should_be_persisted survey
    assert_equal survey.sections.size, num_questions
  end
  
  test "should create a survey with 2 questions" do
    num_questions = 2
    survey = create_survey_with_sections(num_questions, 1)
    should_be_persisted survey
    assert_equal survey.sections.first.questions.size, num_questions
  end

  test "should not create a survey with attempts_number lower than 0" do
    survey = create_survey({:attempts_number => -1})
    should_not_be_persisted survey
  end

  test "should not save survey without all the needed fields" do
    survey_without_name = create_survey({:name => nil})
    survey_without_description = create_survey({:description => nil})
    %w(name description).each do |suffix|
      should_not_be_persisted eval("survey_without_#{suffix}")
    end
  end


end