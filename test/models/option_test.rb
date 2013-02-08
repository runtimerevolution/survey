require 'test_helper'

class OptionTest < ActiveSupport::TestCase

  test "should create a valid option" do
    option = create_option
    should_be_persisted option
  end

  test "should not create a option with empty or nil text fields" do
    optionA = create_option({:text => ""})
    optionB = create_option({:text => nil})
    should_not_be_persisted optionA
    should_not_be_persisted optionB
  end

  test "should be true if option A is correct and option B incorrect" do
    optionA = create_option({:correct => false})
    optionB = create_option({:correct => true})

    should_be_false optionA.correct?
    should_be_true  optionB.correct?
  end

  # correct => default weight is 1
  # incorrect => default weight is 0
  test "should be true weights are synchronized with the correct flag" do
    optionA = create_option({:correct => false})
    optionB = create_option({:correct => true})
    optionC = create_option({:correct => true, :weight => 5})

    should_be_true (optionA.weight == 0)
    should_be_true (optionB.weight == 1)
    should_be_true (optionC.weight == 5)
  end
end