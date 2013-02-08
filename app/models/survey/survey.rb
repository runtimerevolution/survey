class Survey::Survey < ActiveRecord::Base

  self.table_name = "survey_surveys"

  attr_accessible :name, :description, :finished,
    :active, :questions_attributes, :attempts_number

  # relations
  has_many :attempts
  has_many :questions
  accepts_nested_attributes_for :questions,
    :reject_if => ->(q) { q[:text].blank? }, :allow_destroy => true
  # scoping
  scope :active, -> { where(:active => true) }
  scope :inactive, -> { where(:active => false) }


  validates :attempts_number,
    :numericality => { :only_integer => true, :greater_than => -1 }

  # validations
  validates :description, :name, :presence => true, :allow_blank => false
  validate  :check_active_requirements

  # returns all the correct options for current surveys
  def correct_options
    self.questions.map { |question| question.correct_options }.flatten
  end

  # returns all the incorrect options for current surveys
  def incorrect_options
    self.questions.map { |question| question.incorrect_options }.flatten
  end

  def avaliable_for_participant?(participant)
    current_number_of_attempts =
      self.attempts.for_participant(participant).size
    upper_bound = self.attempts_number
    not(current_number_of_attempts >= upper_bound and upper_bound != 0)
  end

  private

  # a surveys only can be activated if has one or more questions
  def check_active_requirements
    if self.active and self.questions.empty?
      errors.add(:active, "Survey without questions cannot be activated")
    end
  end
end
