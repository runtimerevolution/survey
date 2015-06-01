class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"

  acceptable_attributes :text, :question_type, :survey, :likert_min, :likert_max, :likert_min_text, :likert_max_text, options_attributes: Survey::Option::AccessibleAttributes

  belongs_to :survey
  has_many   :options, dependent: :destroy
  accepts_nested_attributes_for :options,
    reject_if: ->(a) { a[:text].blank? },
    allow_destroy: true

  # validations
  validates :text, presence: true, allow_blank: false

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
    return options.correct
  end

  def incorrect_options
    return options.incorrect
  end

  def question_type_class
    @question_type_class ||= self.class.STRING_TYPE_TO_CLASS_MAPPING.fetch(question_type.to_sym).new(self)
  end
end
