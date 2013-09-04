class Survey::Section < ActiveRecord::Base

  self.table_name = "survey_sections"
  
  # relations
  has_many :questions
  accepts_nested_attributes_for :questions,
    :reject_if => ->(q) { q[:text].blank? }, :allow_destroy => true
  
  # validations
  validates :name, :presence => true, :allow_blank => false
end