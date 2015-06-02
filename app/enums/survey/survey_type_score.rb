class Survey::SurveyTypeScore < Survey::SurveyType
  def survey_type_specific_validation
    errors.add(:survey_id, 'A score survey cannot have correct answers') if @survey.correct_options.present?
  end
end