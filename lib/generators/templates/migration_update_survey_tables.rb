class UpdateSurveyTables < ActiveRecord::Migration
  def change
    #Survey Surveys table
    add_column :survey_surveys, :locale_name, :string
    add_column :survey_surveys, :locale_description, :string
    
    #Survey Sections table
    add_column :survey_sections, :locale_head_number, :string
    add_column :survey_sections, :locale_name, :string
    add_column :survey_sections, :locale_description, :string
    
    #Survey Questions table
    add_column :survey_questions, :head_number, :string
    add_column :survey_questions, :description, :string
    add_column :survey_questions, :locale_text, :string
    add_column :survey_questions, :locale_head_number, :string
    add_column :survey_questions, :locale_description, :string
    
    #Survey Options table
    add_column :survey_options, :locale_text, :string
  end
end
