class Survey::Attempt < ActiveRecord::Base

  self.table_name = "survey_attempts"

  # relations

  has_many :answers
  belongs_to :survey
  belongs_to :participant, :polymorphic => true

  #rails 3 attr_accessible support
  if Rails::VERSION::MAJOR < 4
    attr_accessible :participant_id, :survey_id, :answers_attributes, :survey, :winner, :participant
  end
  
  # validations
  validates :participant_id, :participant_type,
    :presence => true
    
  accepts_nested_attributes_for :answers,
    :reject_if =>
      ->(q) { q[:question_id].blank? || q[:option_id].blank? }, 
      allow_destroy: true

  #scopes

  scope :for_survey, ->(survey) {
  where(:survey_id => survey.try(:id))
  }

  scope :exclude_survey, ->(survey) {
  where("NOT survey_id = #{survey.try(:id)}")
  }

  scope :for_participant, ->(participant) {
  where(:participant_id => participant.try(:id),
    :participant_type => participant.class)
  }

  scope :wins, -> { where(:winner => true) }
  scope :looses, -> { where(:winner => false) }
  scope :scores, -> { order("score DESC") }

  # callbacks

  validate :check_number_of_attempts_by_survey, :on => :create
  before_create :collect_scores

  def correct_answers
    self.answers.where(:correct => true)
  end

  def incorrect_answers
    self.answers.where(:correct => false)
  end

  def self.high_score
    scores.first.score
  end

  private

  def check_number_of_attempts_by_survey
    attempts = self.class.for_survey(survey).for_participant(participant)
    upper_bound = self.survey.attempts_number
    if attempts.size >= upper_bound and upper_bound != 0
      errors.add(:questionnaire_id, "Number of attempts exceeded")
    end
  end

  def collect_scores
    self.score = self.answers.map(&:value).reduce(:+)
  end
end
