class Survey::Answer < ActiveRecord::Base

  self.table_name = "survey_answers"
  belongs_to :attempt
  belongs_to :option
  belongs_to :predefined_value
  belongs_to :question

  validates :option_id, :question_id, :presence => true
  validates :predefined_value_id, :presence => true , :if => Proc.new{|a| a.question && a.question.mandatory? && a.question.predefined_values.count > 0 && !([Survey::OptionsType.text, Survey::OptionsType.large_text].include?(a.option.options_type_id))  }
  validates :option_text, :presence => true , :if => Proc.new{|a| a.option && ( a.question && a.question.mandatory? && a.question.predefined_values.count == 0 && [Survey::OptionsType.text, Survey::OptionsType.multi_choices_with_text, Survey::OptionsType.single_choice_with_text, Survey::OptionsType.large_text].include?(a.option.options_type_id)) }
  validates :option_number, :presence => true , :if => Proc.new{|a| a.option && ( a.question && a.question.mandatory? && [Survey::OptionsType.number, Survey::OptionsType.multi_choices_with_number, Survey::OptionsType.single_choice_with_number].include?(a.option.options_type_id)) }
    
  #rails 3 attr_accessible support
  if Rails::VERSION::MAJOR < 4
    attr_accessible :option, :attempt, :question, :question_id, :option_id, :predefined_value_id, :attempt_id, :option_text, :option_number
  end
  
  before_create :characterize_answer
  before_save :check_single_choice_with_field_case

  def value
    unless self.option == nil
      self.option.weight
    else
      Survey::Option.find(option_id).weight
    end
  end

  def correct?
    self.correct or self.option.correct?
  end

  #######
  private
  #######
  
  def characterize_answer
    if option.correct?
      self.correct = true
    end
  end

  def check_single_choice_with_field_case
    if [Survey::OptionsType.multi_choices, Survey::OptionsType.single_choice].include?(self.option.options_type_id)
      self.option_text = nil 
      self.option_number = nil
    end
  end
end