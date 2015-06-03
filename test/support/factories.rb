# Factories

# Create a Survey::Survey
def create_survey(opts = {})
  Survey::Survey.create({
    name: ::Faker::Name.name,
    attempts_number: 3,
    description: ::Faker::Lorem.paragraph(1),
  }.merge(opts))
end

# Create a Survey::Question
def create_question(opts = {})
  Survey::Question.create({
    text:  ::Faker::Lorem.paragraph(1),
  }.merge(opts))
end

# Create a Survey::Question with an option
def create_question_with_option(opts = {})
  Survey::Question.create({
    text:  ::Faker::Lorem.paragraph(1),
    options_attributes: {option: correct_option_attributes}
  }.merge(opts))
end

# Create a Survey::option but not saved
def new_option(opts = {})
  Survey::Option.new(option_attributes.merge(opts))
end

# Create a Survey::Option
def create_option(opts = {})
  Survey::Option.create(option_attributes.merge(opts))
end

def option_attributes
  { text: ::Faker::Lorem.paragraph(1) }
end

def correct_option_attributes
  option_attributes.merge({correct: true})
end

def create_attempt(user: nil, survey: nil, chosen_options: [])
  Survey::Attempt.create do |t|
    t.survey = survey
    t.participant = user
    chosen_options.each do |option|
      t.answers.new(option: option, question: option.question, attempt: t)
    end
  end
end

def create_survey_with_questions(num_questions = 4, num_options = 4,
                                 survey_attributes: {}, questions_attributes: {},
                                 options_attributes: correct_option_attributes)
  survey = create_survey(survey_attributes)
  num_questions.times do
    question = create_question(questions_attributes)
    num_options.times do
      question.options << create_option(option_attributes)
    end
    survey.questions << question
  end
  survey
end

def create_survey_with_questions_and_scores(num_questions = 4, num_options = 4, weight: 10)
  create_survey_with_questions(options_attributes: { weight: weight })
end

# Creates a user attempt. If all correct is true the user will choose all the correct options.
# If if it is false, the user will choose all the incorrect options.
def create_attempt_for(user, survey, all_correct: false)
  chosen_options = all_correct ? survey.correct_options : survey.incorrect_options
  create_attempt({  chosen_options: chosen_options,
                    user: user,
                    survey: survey})
end

def create_attempt_choosing_first_option(user, survey)
  chosen_options = survey.questions.map { |q| q.options.first }
  create_attempt({  chosen_options: chosen_options,
                    user: user,
                    survey: survey})
end

def create_answer(opts = {})
  survey = create_survey_with_questions(6)
  question = survey.questions.first
  option   = survey.questions.first.options.first
  attempt = create_attempt(user: create_user, survey: survey)
  Survey::Answer.create({option: option, attempt: attempt, question: question}.merge(opts))
end

# Dummy Model from Dummy Application
def create_user
  User.create(name: Faker::Name.name)
end

def create_sti_user
  StiUser.create(name: Faker::Name.name)
end