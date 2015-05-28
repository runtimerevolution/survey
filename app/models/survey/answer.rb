class Survey::Answer < ActiveRecord::Base

  self.table_name = "survey_answers"

  acceptable_attributes :attempt, :option, :value_i, :value_s, :correct, :option_id, :question, :question_id

  # associations
  belongs_to :attempt
  belongs_to :option
  belongs_to :question

  # validations
  validates :option_id, :question_id, presence: true
  validates :option_id, uniqueness: { scope: [:attempt_id, :question_id] }

  # callbacks
  after_create :characterize_answer, :attribute_value

  def weight
    option.weight
  end

  def correct?
    self.correct ||= self.option.correct?
  end

  private

  def characterize_answer
    update_attributes!(correct: option.correct?)
  end

  def attribute_value
    update_attributes!(value_s: option.text)
  end
end
