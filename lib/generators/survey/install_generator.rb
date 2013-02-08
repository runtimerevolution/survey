module Survey
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_migration
        unless survey_migration_already_exists?
          timestamp_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          copy_file "migration.rb", "db/migrate/#{timestamp_number}_create_survey.rb"
        end
      end

      private

      def survey_migration_already_exists?
         Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_create_survey.rb$/).first
      end
    end
  end
end