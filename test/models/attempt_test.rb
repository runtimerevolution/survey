require 'test_helper'

class AttemptTest < ActiveSupport::TestCase

  NUMBER_OF_ATTEMPTS = 5

  test "should pass if the user has #{NUMBER_OF_ATTEMPTS} attempts completed" do
    user = create_user
    survey = create_survey({:attempts_number => NUMBER_OF_ATTEMPTS})
    NUMBER_OF_ATTEMPTS.times { create_attempt_for(user, survey) }
    assert_equal NUMBER_OF_ATTEMPTS, number_of_current_attempts(user, survey)
  end

  test "should raise error when the User tries to respond more times than acceptable" do
    user = create_user
    survey = create_survey({:attempts_number => NUMBER_OF_ATTEMPTS})
    (NUMBER_OF_ATTEMPTS + 1).times { create_attempt_for(user, survey) }
    assert_not_equal (NUMBER_OF_ATTEMPTS + 1), number_of_current_attempts(user, survey)
    assert_equal NUMBER_OF_ATTEMPTS, number_of_current_attempts(user, survey)
  end

end