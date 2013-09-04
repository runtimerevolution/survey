module Survey
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def has_surveys
        has_many :survey_attempts, as: :participant, :class_name => ::Survey::Attempt

        define_method("for_survey") do |survey|
          self.survey_attempts.where(:survey_id => survey.id)
        end
      end
    end
  end
end