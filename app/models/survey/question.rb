class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"
  # relations
  has_many   :options
  belongs_to :section
  accepts_nested_attributes_for :options,
    :reject_if => ->(a) { a[:text].blank? },
      :allow_destroy => true
  

  # validations
  validates :text, :presence => true,
    :allow_blank => false

  def correct_options
    options.correct
  end

  def incorrect_options
    options.incorrect
  end
end
