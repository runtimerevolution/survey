# frozen_string_literal: true

module Survey
  # Module ActiveRecord
  module ActiveRecord
    extend ActiveSupport::Concern

    # Module ClassMethods
    module ClassMethods
      def has_surveys # rubocop:disable Naming/PredicateName
        has_many :survey_tentatives, as: :participant, class_name: ::Survey::Attempt.name

        define_method('for_survey') do |survey|
          survey_tentatives.where(survey_id: survey.id)
        end
      end

      def acceptable_attributes(*args)
        const_set('AccessibleAttributes', args + %i[id _destroy])

        # in_rails_3 do
        #   if defined?(self.respond_to?(:attr_accessible))
        #     attr_accessible(*self.const_get('AccessibleAttributes').map { |k| k.is_a?(Hash) ? k.keys.first : k })
        #   end
        # end
      end
    end
  end
end
