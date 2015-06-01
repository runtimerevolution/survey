class Survey::SurveyTypeQuiz
  def type_specific_validation(survey)
    survey.errors.add(:survey_id, 'A poll cannot have answers with weights') if survey.questions.map { |q| q.options.map(&:weight) }.flatten.any? { |w| w != 0 }
  end
end