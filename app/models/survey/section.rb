class Survey::Section < ActiveRecord::Base

  self.table_name = "survey_sections"
  
  # relations
  has_many :questions
  accepts_nested_attributes_for :questions,
    :reject_if => ->(q) { q[:text].blank? }, :allow_destroy => true
  
  # validations
  validates :name, :presence => true, :allow_blank => false
  validate  :check_questions_requirements
  
  def name
    I18n.locale == I18n.default_locale ? super : locale_name || super
  end
  
  def description
    I18n.locale == I18n.default_locale ? super : locale_description || super
  end
  
  def head_number
    I18n.locale == I18n.default_locale ? super : locale_head_number || super
  end
  
  #######
  private
  #######
  
  # a section only can be saved if has one or more questions and options
  def check_questions_requirements
    if self.questions.empty? || self.questions.collect(&:options).empty?
      errors.add(:base, "Section without questions or options cannot be saved")
    end
  end
end