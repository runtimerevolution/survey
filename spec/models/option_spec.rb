# frozen_string_literal: true

require 'rails_helper'

describe Survey::Option, type: :model do # rubocop:disable Metrics/BlockLength
  let!(:survey) { create(:survey) }
  let!(:question) { create(:question, survey: survey) }
  let!(:option) { create(:option, question: question) }

  it 'should create a valid option' do
    expect(option.new_record?).to eq(false)
    expect(option.valid?).to eq(true)
  end

  it 'should not create a option with empty or nil text fields' do
    option_a = build(:option, question: question, text: '')
    option_b = build(:option, question: question, text: nil)
    expect { option_a.save! }.to raise_error('Validation failed: Text can\'t be blank')
    expect(option_a.valid?).to eq(false)
    expect { option_b.save! }.to raise_error('Validation failed: Text can\'t be blank')
    expect(option_b.valid?).to eq(false)
  end

  it 'should be true if option A is correct and option B incorrect' do
    option_a = build(:option, question: question, correct: true)
    option_b = build(:option, question: question, correct: false)

    expect(option_a.correct?).to eq(true)
    expect(option_b.correct?).to eq(false)
  end

  it 'should be true weights are synchronized with the correct flag' do
    option_a = create(:option, question: question, correct: false)
    option_b = create(:option, question: question, correct: true)
    option_c = create(:option, question: question, correct: true, weight: 5)

    expect(option_a.weight).to eq(0)
    expect(option_b.weight).to eq(1)
    expect(option_c.weight).to eq(5)
  end
end
