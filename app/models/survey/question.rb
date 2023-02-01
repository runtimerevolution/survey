# frozen_string_literal: true

require 'survey/option'

module Survey
  # Class Question
  class Question < ::ActiveRecord::Base
    self.table_name = 'survey_questions'

    acceptable_attributes :text, :survey, options_attributes: ::Survey::Option::AccessibleAttributes

    # relations
    belongs_to :survey
    has_many   :options, dependent: :destroy
    accepts_nested_attributes_for :options,
                                  reject_if: ->(a) { a[:text].blank? },
                                  allow_destroy: true

    # validations
    validates :text, presence: true, allow_blank: false

    def correct_options
      options.correct
    end

    def incorrect_options
      options.incorrect
    end
  end
end
