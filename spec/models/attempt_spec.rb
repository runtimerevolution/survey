# frozen_string_literal: true

require 'rails_helper'
NUMBER_OF_ATTEMPTS = 5

describe Survey::Attempt, type: :model do
  let!(:participant) { create(:user) }
  let!(:survey) { create(:survey, attempts_number: NUMBER_OF_ATTEMPTS) }

  it "should pass if the user has #{NUMBER_OF_ATTEMPTS} attempts completed" do
    NUMBER_OF_ATTEMPTS.times { create(:attempt, survey: survey, participant: participant) }
    expect(participant.for_survey(survey).size).to eq(NUMBER_OF_ATTEMPTS)
  end

  it 'should raise error when the User tries to respond more times than acceptable' do
    NUMBER_OF_ATTEMPTS.times { create(:attempt, survey: survey, participant: participant) }
    extra_attempt = build(:attempt, survey: survey, participant: participant)
    expect(participant.for_survey(survey).size).to eq(NUMBER_OF_ATTEMPTS)
    expect { extra_attempt.save! }.to raise_error('Validation failed: Survey Number of attempts exceeded')
  end
end
