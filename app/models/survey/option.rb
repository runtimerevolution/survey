class Survey::Option < ActiveRecord::Base

  self.table_name = "survey_options"
  #relations
  belongs_to :question
  
  #rails 3 attr_accessible support
  if Rails::VERSION::MAJOR < 4
    attr_accessible :text, :correct, :weight, :question_id, :locale_text, :options_type_id
  end
  
  # validations
  validates :text, :presence => true, :allow_blank => false, :if => Proc.new{|o| [Survey::OptionsType.multi_choices, Survey::OptionsType.single_choice, Survey::OptionsType.single_choice_with_text, Survey::OptionsType.single_choice_with_number, Survey::OptionsType.multi_choices_with_text, Survey::OptionsType.multi_choices_with_number].include?(o.options_type_id) }
  validates :options_type_id, :presence => true
  validates_inclusion_of :options_type_id, :in => Survey::OptionsType.options_type_ids, :unless => Proc.new{|o| o.options_type_id.blank?}
  
  scope :correct, -> {where(:correct => true) }
  scope :incorrect, -> {where(:correct => false) }

  before_create :default_option_weigth

  def to_s
    self.text
  end

  def correct?
    self.correct == true
  end
  
  def text
    I18n.locale == I18n.default_locale ? super : locale_text.blank? ? super : locale_text
  end
  
  #######
  private
  #######
  
  def default_option_weigth
    if self.correct and self.weight == 0
      self.weight =  1
    end
  end

end
