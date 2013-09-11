class Survey::Option < ActiveRecord::Base

  self.table_name = "survey_options"
  #relations
  belongs_to :question
  
  # validations
  validates :text, :presence => true, :allow_blank => false, :if => Proc.new{|o| o.options_type_id == Survey::OptionsType.multi_choices || o.options_type_id == Survey::OptionsType.single_choice }
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
    I18n.locale == I18n.default_locale ? super : locale_text || super
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
