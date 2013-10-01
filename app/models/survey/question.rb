class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"
  # relations
  has_many   :options
  has_many   :predefined_values
  belongs_to :section
  
  #rails 3 attr_accessible support
  if Rails::VERSION::MAJOR < 4
    attr_accessible :options_attributes, :predefined_values_attributes, :text, :section_id, :head_number, :description, :locale_text, :locale_head_number, :locale_description, :questions_type_id
  end
  
  accepts_nested_attributes_for :options,
    :reject_if => ->(a) { a[:options_type_id].blank? },
      :allow_destroy => true
  
  accepts_nested_attributes_for :predefined_values,
    :reject_if => ->(a) { a[:name].blank? },
      :allow_destroy => true

  # validations
  validates :text, :presence => true, :allow_blank => false
  validates :questions_type_id, :presence => true
  validates_inclusion_of :questions_type_id, :in => Survey::QuestionsType.questions_type_ids, :unless => Proc.new{|q| q.questions_type_id.blank?}
  
  scope :mandatory_only, -> { where(:mandatory => true) }
  
  def correct_options
    options.correct
  end

  def incorrect_options
    options.incorrect
  end
  
  def text
    I18n.locale == I18n.default_locale ? super : locale_text.blank? ? super : locale_text
  end
  
  def description
    I18n.locale == I18n.default_locale ? super : locale_description.blank? ? super : locale_description
  end
  
  def head_number
    I18n.locale == I18n.default_locale ? super : locale_head_number.blank? ? super : locale_head_number
  end
  
  def mandatory?
    self.mandatory == true
  end
end
