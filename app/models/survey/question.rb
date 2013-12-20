class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"

  acceptable_attributes :text, :survey, :options_attributes => Survey::Option::AccessibleAttributes

  # relations
  belongs_to :survey
  has_many   :options, :dependent => :destroy
  accepts_nested_attributes_for :options,
    :reject_if => ->(a) { a[:text].blank? },
    :allow_destroy => true

  # validations
  validates :text, :presence => true, :allow_blank => false

  def correct_options
    return options.correct
  end

  def incorrect_options
    return options.incorrect
  end
end
