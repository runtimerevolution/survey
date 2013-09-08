module Survey
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_migration
        timestamp_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        
        unless survey_migration_already_exists?
          copy_file "migration.rb", "db/migrate/#{timestamp_number}_create_survey.rb"
        end
        
        unless section_migration_already_exists?
          timestamp_number += 1
          copy_file "migration_section.rb", "db/migrate/#{timestamp_number}_create_sections.rb"
        end
        
        unless update_survey_tables_migration_already_exists?
          timestamp_number += 1
          copy_file "migration_update_survey_tables.rb", "db/migrate/#{timestamp_number}_update_survey_tables.rb"
        end
        
        unless add_types_to_questions_and_options_migration_already_exists?
          timestamp_number += 1
          copy_file "migration_add_types_to_questions_and_options.rb", "db/migrate/#{timestamp_number}_add_types_to_questions_and_options.rb"
        end
        
      end

      #######
      private
      #######
      
      def survey_migration_already_exists?
         Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_create_survey.rb$/).first
      end
      
      def section_migration_already_exists?
         Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_create_sections.rb$/).first
      end
      
      def update_survey_tables_migration_already_exists?
         Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_update_survey_tables.rb$/).first
      end
      
      def add_types_to_questions_and_options_migration_already_exists?
         Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_add_types_to_questions_and_options.rb$/).first
      end
    end
  end
end