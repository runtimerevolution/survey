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

        in_rails_3 do
          if defined?(self.respond_to?(:attr_accessible))
            attr_accessible(*self.const_get('AccessibleAttributes').map { |k| k.is_a?(Hash) ? k.keys.first : k })
          end
        end

      end
    end
  end
end