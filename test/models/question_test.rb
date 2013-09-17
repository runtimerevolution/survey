require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "should create a valid question" do
    question = create_question
    should_be_persisted question
  end
  
  test "should create a valid question with multi choices type" do
    question = create_question({:questions_type_id => Survey::QuestionsType.general})
    should_be_persisted question
    assert_equal question.questions_type_id, Survey::QuestionsType.general
  end
  
  test "should create a valid question with accepted type" do
    question = create_question({:questions_type_id => 99 })
    
    should_not_be_persisted question
  end
  
  test "should create a valid question with predefined_values" do
    question = create_question({:predefined_values => [create_predefined_value] })
    
    should_be_persisted question
    assert_equal question.predefined_values.count, 1
  end
  
  test "should not create a question with a empty or nil questions_type_id field" do
    question = create_question({:questions_type_id => nil})
    
    should_not_be_persisted question
  end

  test "should not create a question with a empty or nil text fields" do
    question1 = create_question({:text => nil})
    question2 = create_question({:text => ""})

    should_not_be_persisted question1
    should_not_be_persisted question2
  end

  test "should return true when passed a correct answer to the question object" do
    question = create_question
    question.options.create(correct_option_attributes)
    6.times { question.options.create(option_attributes) }

    correct_option = question.options.first
    should_be_true question.correct_options.include?(correct_option)

    # by default when we create a new question it creates a correct answer directly
    # when we create the second question with the correct flag equal a true
    # we have to start the iteration in position number two
    question.options[2..question.options.size-2].each do |option|
      should_be_false question.correct_options.include?(option)
    end
  end

end