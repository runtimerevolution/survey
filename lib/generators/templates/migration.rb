class CreateSurvey < ActiveRecord::Migration
  def self.up

    # survey surveys logic
    create_table :survey_surveys do |t|
      t.string  :name
      t.text    :description
      t.integer :attempts_number, :default => 0
      t.boolean :finished, :default => false
      t.boolean :active, :default => false

      t.timestamps
    end

    create_table :survey_questions do |t|
      t.integer :survey_id
      t.string  :text

      t.timestamps
    end

    create_table :survey_options do |t|
      t.integer :question_id
      t.integer :weight, :default => 0
      t.string :text
      t.boolean :correct

      t.timestamps
    end

    # survey answer logic
    create_table :survey_attempts do |t|
      t.belongs_to :participant, :polymorphic => true
      t.integer    :survey_id
      t.boolean    :winner
      t.integer    :score
    end

    create_table :survey_answers do |t|
      t.integer    :attempt_id
      t.integer    :question_id
      t.integer    :option_id
      t.boolean    :correct
      t.timestamps
    end
  end

  def self.down
    drop_table :survey_surveys
    drop_table :survey_questions
    drop_table :survey_options

    drop_table :survey_attempts
    drop_table :survey_answers
  end
end
