class Survey::QuestionTypeLikert < Survey::QuestionType
  def type_specific_validation
    @question.errors.add(:likert_max, 'needs to be higher than likert min') unless (@question.likert_max - @question.likert_min) > 0
  end
end
