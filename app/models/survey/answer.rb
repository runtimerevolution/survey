class Survey::Answer < ActiveRecord::Base

  self.table_name = "survey_answers"
  belongs_to :attempt
  belongs_to :option
  belongs_to :question

  validates :option_id, :question_id, :presence => true
  validates :option_number, :presence => true , :if => Proc.new{|a| a.option && a.option.options_type_id == Survey::OptionsType.number}
  validates :option_text, :presence => true , :if => Proc.new{|a| a.option && a.option.options_type_id == Survey::OptionsType.text}
  
  before_create :characterize_answer

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

  private

  def characterize_answer
    if option.correct?
      self.correct = true
    end
  end

end
