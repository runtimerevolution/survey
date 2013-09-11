class Survey::Question < ActiveRecord::Base

  self.table_name = "survey_questions"
  # relations
  has_many   :options
  belongs_to :section
  accepts_nested_attributes_for :options,
    :reject_if => ->(a) { a[:options_type_id].blank? },
      :allow_destroy => true
  

  # validations
  validates :text, :presence => true, :allow_blank => false
  validates :questions_type_id, :presence => true
  validates_inclusion_of :questions_type_id, :in => Survey::QuestionsType.questions_type_ids, :unless => Proc.new{|q| q.questions_type_id.blank?}
  
  def correct_options
    options.correct
  end

  def incorrect_options
    options.incorrect
  end
  
  def text
    I18n.locale == I18n.default_locale ? super : locale_text || super
  end
  
  def description
    I18n.locale == I18n.default_locale ? super : locale_description || super
  end
  
  def head_number
    I18n.locale == I18n.default_locale ? super : locale_head_number || super
  end
end
