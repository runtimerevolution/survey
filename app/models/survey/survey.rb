class Survey::Survey < ActiveRecord::Base

  self.table_name = "survey_surveys"
  
  # relations
  has_many :attempts
  has_many :sections
  
  accepts_nested_attributes_for :sections,
    :reject_if => ->(q) { q[:name].blank? }, :allow_destroy => true
    
  scope :active, -> { where(:active => true) }
  scope :inactive, -> { where(:active => false) }


  validates :attempts_number,
    :numericality => { :only_integer => true, :greater_than => -1 }

  # validations
  validates :description, :name, :presence => true, :allow_blank => false
  validate  :check_active_requirements

  # returns all the correct options for current surveys
  def correct_options
    Survey::Question.where(:section_id => self.sections.collect(&:id)).map { |question| question.correct_options }.flatten
  end

  # returns all the incorrect options for current surveys
  def incorrect_options
    Survey::Question.where(:section_id => self.sections.collect(&:id)).map { |question| question.incorrect_options }.flatten
  end

  def avaliable_for_participant?(participant)
    current_number_of_attempts =
      self.attempts.for_participant(participant).size
    upper_bound = self.attempts_number
    not(current_number_of_attempts >= upper_bound and upper_bound != 0)
  end

  #######
  private
  #######
  
  # a surveys only can be activated if has one or more sections and questions
  def check_active_requirements
    if self.active and self.sections.empty? and self.sections.collect(&:questions).empty?
      errors.add(:active, "Survey without sections or questions cannot be activated")
    end
  end
end
