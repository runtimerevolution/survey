class Survey::Question < ActiveRecord::Base

  self.table_name = 'survey_questions'

  acceptable_attributes :text, :question_type, :survey, :likert_options, options_attributes: Survey::Option::AccessibleAttributes

  belongs_to :survey
  has_many   :options, dependent: :destroy
  accepts_nested_attributes_for :options,
    reject_if: ->(a) { a[:text].blank? },
    allow_destroy: true

  # validations
  validates :text, presence: true, allow_blank: false
  validates :options, presence: true
  validate  :question_type_specific_validation

  STRING_TYPE_TO_CLASS_MAPPING =
    {
      single:   Survey::QuestionTypeSingle,
      multiple: Survey::QuestionTypeMultiple,
      likert:   Survey::QuestionTypeLikert
    }

  def self.question_types
    STRING_TYPE_TO_CLASS_MAPPING.keys
  end

  def correct_options
    options.correct
  end

  def incorrect_options
    options.incorrect
  end

  def likert_max
    likert_options_symbols.map { |option| option[:position] }.max
  end

  def likert_min
    likert_options_symbols.map { |option| option[:position] }.min
  end

  def likert_options_symbols
    likert_options.map { |option| HashWithIndifferentAccess.new(option) }
  end

  def question_type_class
    @question_type_class ||= self.class::STRING_TYPE_TO_CLASS_MAPPING.fetch(question_type.to_sym).new(self)
  end

  def question_type_specific_validation
    question_type_class.question_type_specific_validation if question_type_class.respond_to?(:question_type_specific_validation)
  end
end
