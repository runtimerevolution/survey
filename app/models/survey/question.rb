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

  def self.question_types
    string_type_to_class_mapping.keys
  end

  def self.string_type_to_class_mapping
    {
      single:   Survey::QuestionTypeSingle,
      multiple: Survey::QuestionTypeMultiple,
      likert:   Survey::QuestionTypeLikert
    }    
  end

  def correct_options
    return options.correct
  end

  def incorrect_options
    return options.incorrect
  end

  def question_type_class
    @question_type_class ||= self.class.string_type_to_class_mapping[question_type.to_sym].new
  end
end
