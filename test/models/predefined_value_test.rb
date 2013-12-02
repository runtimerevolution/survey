require 'test_helper'

class PredefinedValueTest < ActiveSupport::TestCase

  test "should create a valid predefined_value" do
    predefined_value = create_predefined_value
    should_be_persisted predefined_value
  end
  
  test "should not create a predefined_value with a empty or nil name field" do
    predefined_value_a = create_predefined_value({:name => nil})
    predefined_value_b = create_predefined_value({:name => ''})
    
    should_not_be_persisted predefined_value_a
    should_not_be_persisted predefined_value_b
  end
end