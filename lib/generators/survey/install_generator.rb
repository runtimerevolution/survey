module Survey
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_migration
        timestamp_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        
        migration_files = [{new_file_name: "create_survey", origin_file_name: "migration"},
                           {new_file_name: "create_sections", origin_file_name: "migration_section"},
                           {new_file_name: "update_survey_tables", origin_file_name: "migration_update_survey_tables"},
                           {new_file_name: "add_types_to_questions_and_options", origin_file_name: "migration_add_types_to_questions_and_options"},
                           {new_file_name: "add_head_number_to_options_table", origin_file_name: "migration_add_head_number_to_options_table"},
                           {new_file_name: "create_predefined_values_table", origin_file_name: "migration_create_predefined_values_table"},
                           {new_file_name: "add_mandatory_to_questions_table", origin_file_name: "migration_add_mandatory_to_questions_table"}
                          ]
        
        migration_files.each do |migration_file|
          unless already_exists?(migration_file[:new_file_name])
            copy_file "#{migration_file[:origin_file_name]}.rb", "db/migrate/#{timestamp_number}_#{migration_file[:new_file_name]}.rb"
            timestamp_number += 1
          end
        end
      end

      #######
      private
      #######
      
      def already_exists?(file_name)
        Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(Regexp.new('\d+_' + file_name + '.rb$')).first
      end
    end
  end
end