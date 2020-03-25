module Survey
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def has_surveys
        has_many :survey_tentatives, as: :participant, :class_name => ::Survey::Attempt

        define_method("for_survey") do |survey|
          self.survey_tentatives.where(:survey_id => survey.id)
        end
      end

      def acceptable_attributes(*args)
        self.const_set('AccessibleAttributes', args + [:id, :_destroy])
      end
    end
  end
end
