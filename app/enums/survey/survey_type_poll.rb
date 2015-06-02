class Survey::SurveyTypePoll < Survey::SurveyType
  def type_specific_validation
    @survey.errors.add(:survey_id, 'A poll cannot have correct answers') if @survey.correct_options.present?
    @survey.errors.add(:survey_id, 'A poll cannot have answers with weights') if @survey.questions.flat_map { |q| q.options.map(&:weight) }.any? { |w| w != 0 }
  end
end