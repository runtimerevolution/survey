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

  test "should create a answer with a option_number field for options with number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.number)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => 12)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
  end
  
  test "should not create a answer with a nil option_number field for options with number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.number)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => nil)
    
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should create a answer with a option_text field for options with text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.text)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => Faker::Name.name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
  end
  
  test "should not create a answer with a nil option_text field for options with text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.text)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => nil)
    
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "can create a answer already made to the same attempt" do
    answer_try_1  = create_answer
    attempt  = answer_try_1.attempt
    question = answer_try_1.question
    option   = (question.options - [answer_try_1.option]).first
    answer_try_2 = create_answer(:attempt => attempt, :question => question, :option => option)

    should_be_persisted answer_try_1
    should_be_persisted answer_try_2
  end
end