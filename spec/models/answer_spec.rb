# frozen_string_literal: true

require 'rails_helper'

describe Survey::Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:survey) { create(:survey) }
  let!(:attempt) { create(:attempt, survey: survey, participant: user) }
  let!(:question) { create(:question, survey: survey) }
  let!(:option) { create(:option, question: question) }
  let!(:answer) { create(:answer, attempt: attempt, option: option, question: question) }

  it 'should create a valid answer' do
    expect(answer.valid?).to eq(true)
  end

  it 'should not create a answer with a nil option' do
    answer = build(:answer, option: nil)
    expect(answer.valid?).to eq(false)
  end

  it 'should not create a answer with a nil option' do
    answer = build(:answer, question: nil)
    expect(answer.valid?).to eq(false)
  end

  it 'should not create a answer with a nil option' do
    copy_answer = build(:answer, attempt: answer.attempt, question: answer.question, option: answer.option)
    expect { copy_answer.save! }.to raise_error('Validation failed: Option has already been taken')
  end
end
