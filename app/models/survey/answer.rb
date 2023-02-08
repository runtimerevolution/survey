# frozen_string_literal: true

module Survey
  # Class Answer
  class Answer < ::ActiveRecord::Base
    self.table_name = 'survey_answers'
    acceptable_attributes :attempt, :option, :correct, :option_id, :question, :question_id

    # associations
    belongs_to :attempt
    belongs_to :option
    belongs_to :question

    # validations
    validates :option_id, :question_id, presence: true
    validates :option_id, uniqueness: { scope: %i[attempt_id question_id] }

    # callbacks
    after_create :characterize_answer

    def value
      points = (option.nil? ? Option.find(option_id) : option).weight
      correct? ? points : - points
    end

    def correct?
      correct ||= option.correct?
      correct
    end

    private

    def characterize_answer
      update_attribute(:correct, option.correct?)
    end
  end
end
