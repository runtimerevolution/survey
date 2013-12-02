require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "should create a valid answer" do
    answer = create_answer
    should_be_persisted answer
  end

  test "should not create an answer with a nil option" do
    answer = create_answer({:option => nil})
    should_not_be_persisted answer
  end

  test "should not create an answer with a nil question" do
    answer = create_answer({:question => nil})
    should_not_be_persisted answer
  end

  test "should create an answer with a option_number field for options with number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.number)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => 12)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
  end
  
  test "should not create an answer with a nil option_number field for options with number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.number, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => nil)
    
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should create an answer with a option_text field for options with text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => Faker::Name.name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
  end
  
  test "should not create an answer with a nil option_text field for options with text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => nil)
    
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should create an answer with a option_text field for options with large_text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.large_text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => Faker::Name.name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
  end
  
  test "should not create an answer with a nil option_text field for options with large_text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.large_text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => nil)
    
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should create an answer with a option_text field for options with multi_choices_with_text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.multi_choices_with_text, true)
    faker_name = Faker::Name.name
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => faker_name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
    assert_equal answer_try_1.option_text, faker_name
  end
  
  test "should not create an answer with empty option_text field for options with multi_choices_with_text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.multi_choices_with_text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => nil)
  
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should not create an answer with empty option_text field for options with single_choice_with_text type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.single_choice_with_text, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => nil)
  
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should not create an answer with empty option_number field for options with multi_choices_with_number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.multi_choices_with_number, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => nil)
  
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should not create an answer with empty option_number field for options with single_choice_with_number type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.single_choice_with_number, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_number => nil)
  
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "should create an answer with options with multi_choices type, and text field should be empty" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.multi_choices, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => Faker::Name.name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
    assert_equal answer_try_1.option_text, nil
  end
  
  test "should create an answer with options with single_choice type, and text field should be empty" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.single_choice, true)
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :option_text => Faker::Name.name)
  
    should_be_persisted survey
    should_be_persisted answer_try_1
    assert_equal answer_try_1.option_text, nil
  end
  
  test "should create an answer with a predefined_value_id field for single_choice type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.single_choice, true)
    predefined_value = create_predefined_value
    question.predefined_values << predefined_value
    question.save
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :predefined_value_id => predefined_value.id)
  
    should_be_persisted survey
    should_be_persisted question
    should_be_persisted answer_try_1
    assert_equal answer_try_1.predefined_value_id, predefined_value.id
  end
  
  test "should not create an answer with an empty predefined_value_id field for single_choice type" do
    survey, option, attempt, question = create_answer_with_option_type(Survey::OptionsType.single_choice, true)
    question.predefined_values << create_predefined_value
    question.save
    answer_try_1 = create_answer(:option => option, :attempt => attempt, :question => question, :predefined_value_id => nil)
  
    should_be_persisted survey
    should_not_be_persisted answer_try_1
  end
  
  test "can create an answer already made to the same attempt" do
    answer_try_1  = create_answer
    attempt  = answer_try_1.attempt
    question = answer_try_1.question
    option   = (question.options - [answer_try_1.option]).first
    answer_try_2 = create_answer(:attempt => attempt, :question => question, :option => option)

    should_be_persisted answer_try_1
    should_be_persisted answer_try_2
  end
end