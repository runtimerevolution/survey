require 'test_helper'

class OptionTest < ActiveSupport::TestCase

  test "should create a valid option" do
    option = create_option
    should_be_persisted option
  end
  
  test "should create a valid option with multi choices type" do
    option = create_option(:options_type_id => Survey::OptionsType.multi_choices)
    
    should_be_persisted option
    assert_equal option.options_type_id, Survey::OptionsType.multi_choices
  end
  
  test "should create a valid option with single choice type" do
    option = create_option(:options_type_id => Survey::OptionsType.single_choice)
    
    should_be_persisted option
    assert_equal option.options_type_id, Survey::OptionsType.single_choice
  end
  
  test "should create a valid option with number type" do
    option = create_option(:options_type_id => Survey::OptionsType.number)
    
    should_be_persisted option
    assert_equal option.options_type_id, Survey::OptionsType.number
  end
  
  test "should create a valid option with text type" do
    option = create_option(:options_type_id => Survey::OptionsType.text)
    
    should_be_persisted option
    assert_equal option.options_type_id, Survey::OptionsType.text
  end
  
  test "should create a valid option with large_text type" do
    option = create_option(:options_type_id => Survey::OptionsType.large_text)
    
    should_be_persisted option
    assert_equal option.options_type_id, Survey::OptionsType.large_text
  end
  
  test "should create a valid option with accepted type" do
    option = create_option(:options_type_id => 99)
    
    should_not_be_persisted option
  end
  
  test "should not create an option with a empty or nil options_type_id field" do
    option = create_option(:options_type_id => nil)
    
    should_not_be_persisted option
  end
  
  test "should create a option with empty or nil text fields for text or number types" do
    optionA = create_option({:text => "", :options_type_id => Survey::OptionsType.text})
    optionB = create_option({:text => nil, :options_type_id => Survey::OptionsType.text})
    
    optionC = create_option({:text => "", :options_type_id => Survey::OptionsType.number})
    optionD = create_option({:text => nil, :options_type_id => Survey::OptionsType.number})
    
    should_be_persisted optionA
    should_be_persisted optionB
    
    should_be_persisted optionC
    should_be_persisted optionD
  end

  test "should not create a option with empty or nil text fields for multi_choices or single_choice types" do
    optionA = create_option({:text => "", :options_type_id => Survey::OptionsType.multi_choices})
    optionB = create_option({:text => nil, :options_type_id => Survey::OptionsType.multi_choices})
    
    optionC = create_option({:text => "", :options_type_id => Survey::OptionsType.single_choice})
    optionD = create_option({:text => nil, :options_type_id => Survey::OptionsType.single_choice})
    
    optionE = create_option({:text => "", :options_type_id => Survey::OptionsType.multi_choices_with_text})
    optionF = create_option({:text => nil, :options_type_id => Survey::OptionsType.multi_choices_with_text})
    
    optionG = create_option({:text => "", :options_type_id => Survey::OptionsType.single_choice_with_text})
    optionH = create_option({:text => nil, :options_type_id => Survey::OptionsType.single_choice_with_text})
    
    optionI = create_option({:text => "", :options_type_id => Survey::OptionsType.multi_choices_with_number})
    optionJ = create_option({:text => nil, :options_type_id => Survey::OptionsType.multi_choices_with_number})
    
    optionK = create_option({:text => "", :options_type_id => Survey::OptionsType.single_choice_with_number})
    optionL = create_option({:text => nil, :options_type_id => Survey::OptionsType.single_choice_with_number})
    
    should_not_be_persisted optionA
    should_not_be_persisted optionB
    
    should_not_be_persisted optionC
    should_not_be_persisted optionD
    
    should_not_be_persisted optionE
    should_not_be_persisted optionF
    
    should_not_be_persisted optionG
    should_not_be_persisted optionH
    
    should_not_be_persisted optionI
    should_not_be_persisted optionJ
    
    should_not_be_persisted optionK
    should_not_be_persisted optionL
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