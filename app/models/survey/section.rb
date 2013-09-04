class Survey::Section < ActiveRecord::Base

  self.table_name = "survey_sections"
  
  # relations
  has_many :questions
  accepts_nested_attributes_for :questions,
    :reject_if => ->(q) { q[:text].blank? }, :allow_destroy => true
  
  # validations
  validates :name, :presence => true, :allow_blank => false
  
  def name
    I18n.locale == I18n.default_locale ? super : locale_name || super
  end
  
  def description
    I18n.locale == I18n.default_locale ? super : locale_description || super
  end
  
  def head_number
    I18n.locale == I18n.default_locale ? super : locale_head_number || super
  end
end