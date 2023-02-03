# frozen_string_literal: true

require 'rails_helper'

describe Survey::Survey, type: :model do # rubocop:disable Metrics/BlockLength
  let!(:survey) { create(:survey) }

  it 'should create a valid survey without questions' do
    expect(survey.new_record?).to eq(false)
    expect(survey.valid?).to eq(true)
  end

  it 'should not create a survey with active flag true and empty questions collection' do
    survey_a = build(:survey, active: true)
    survey_b = build(:survey, num_questions: 5)
    survey_b.active = true
    survey_b.save

    expect { survey_a.save! }.to raise_error('Validation failed: Active Survey without questions cannot be activated')
    expect(survey_a.valid?).to eq(false)
    expect(survey_b.valid?).to eq(true)
    expect(survey_b.new_record?).to eq(false)
  end

  it 'should create a survey with 6 questions' do
    survey = create(:survey, num_questions: 6)
    expect(survey.new_record?).to eq(false)
    expect(survey.valid?).to eq(true)
    expect(survey.questions.size).to eq(6)
  end

  it 'should not create a survey with attempts_number lower than 0' do
    survey = build(:survey, attempts_number: -1)
    expect { survey.save! }.to raise_error('Validation failed: Attempts number must be greater than -1')
    expect(survey.valid?).to eq(false)
  end

  it 'should not save survey without all the needed fields' do
    survey_without_name = build(:survey, name: nil)
    survey_without_description = build(:survey, description: nil)
    expect { survey_without_name.save! }.to raise_error('Validation failed: Name can\'t be blank')
    expect(survey_without_name.valid?).to eq(false)
    expect { survey_without_description.save! }.to raise_error('Validation failed: Description can\'t be blank')
    expect(survey_without_description.valid?).to eq(false)
  end
end
