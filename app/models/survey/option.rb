# frozen_string_literal: true

module Survey
  # Class Option
  class Option < ::ActiveRecord::Base
    self.table_name = 'survey_options'
    acceptable_attributes :text, :correct, :weight

    # relations
    belongs_to :question

    # validations
    validates :text, presence: true, allow_blank: false

    # scopes
    scope :correct,   -> { where(correct: true)  }
    scope :incorrect, -> { where(correct: false) }

    # callbacks
    before_create :default_option_weight

    def to_s
      text
    end

    def correct?
      (correct == true)
    end

    private

    def default_option_weight
      weight = 1 if weight && correct? && weight.zero?
      weight
    end
  end
end
