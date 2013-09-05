class UpdateSurveyTables < ActiveRecord::Migration
  def change
    #Survey Surveys table
    add_column :survey_surveys, :locale_name, :string
    add_column :survey_surveys, :locale_description, :text
    
    #Survey Sections table
    add_column :survey_sections, :locale_head_number, :string
    add_column :survey_sections, :locale_name, :string
    add_column :survey_sections, :locale_description, :text
    
    #Survey Questions table
    add_column :survey_questions, :head_number, :string
    add_column :survey_questions, :description, :text
    add_column :survey_questions, :locale_text, :string
    add_column :survey_questions, :locale_head_number, :string
    add_column :survey_questions, :locale_description, :text
    
    #Survey Options table
    add_column :survey_options, :locale_text, :string
  end
end
