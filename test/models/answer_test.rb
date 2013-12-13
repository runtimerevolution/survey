require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "should create a valid answer" do
    answer = create_answer
    should_be_persisted answer
  end

  test "should not create a answer with a nil option" do
    answer = create_answer({:option => nil})
    should_not_be_persisted answer
  end

  test "should not create a answer with a nil question" do
    answer = create_answer({:question => nil})
    should_not_be_persisted answer
  end

  test "should not create a answer already made to the same attempt/option" do
    answer_try_1  = create_answer
    attempt  = answer_try_1.attempt
    question = answer_try_1.question
    option   = answer_try_1.option
    answer_try_2 = create_answer(:attempt => attempt, :question => question, :option => option)

    should_be_persisted answer_try_1
    should_not_be_persisted answer_try_2
  end
end