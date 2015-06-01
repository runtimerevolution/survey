class Survey::SurveyTypeScore
  def type_specific_validation(survey)
    errors.add(:survey_id, 'A score survey cannot have correct answers') if survey.correct_options.present?
  end
end