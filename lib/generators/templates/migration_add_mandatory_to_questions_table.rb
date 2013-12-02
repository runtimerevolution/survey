class AddMandatoryToQuestionsTable < ActiveRecord::Migration
  def change
    #Survey Questions table
    add_column :survey_questions, :mandatory, :boolean, :default => false
  end
end
