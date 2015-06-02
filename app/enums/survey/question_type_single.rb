class Survey::QuestionTypeSingle < Survey::QuestionType
  def type_specific_validation
    @question.errors.add(:options, 'single type questions need more than one option') unless @question.options.length > 1
  end
end