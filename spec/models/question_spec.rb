# frozen_string_literal: true

require 'rails_helper'

describe Survey::Question, type: :model do
  let!(:survey) { create(:survey) }
  let!(:question) { create(:question, survey: survey) }

  it 'should create a valid question' do
    expect(question.new_record?).to eq(false)
    expect(question.valid?).to eq(true)
  end

  it 'should not create a question with a empty or nil text fields' do
    question1 = build(:question, survey: survey, text: nil)
    question2 = build(:question, survey: survey, text: '')
    expect { question1.save! }.to raise_error('Validation failed: Text can\'t be blank')
    expect(question1.valid?).to eq(false)
    expect { question2.save! }.to raise_error('Validation failed: Text can\'t be blank')
    expect(question2.valid?).to eq(false)
  end

  it 'should return true when passed a correct answer to the question object' do
    correct_option = create(:option, question: question, correct: true)
    6.times { create(:option, question: question, correct: false) }

    expect(question.correct_options.include?(correct_option)).to eq(true)

    # by default when we create a new question it creates a correct answer directly
    # when we create the second question with the correct flag equal a true
    # we have to start the iteration in position number two
    question.options[1..question.options.size - 1].each do |option|
      expect(question.correct_options.include?(option)).to eq(false)
    end
  end
end
