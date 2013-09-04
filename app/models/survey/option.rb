class Survey::Option < ActiveRecord::Base

  self.table_name = "survey_options"
  #relations
  belongs_to :question
  
  # validations
  validates :text, :presence => true,
    :allow_blank => false

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
