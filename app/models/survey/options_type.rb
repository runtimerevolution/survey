class Survey::OptionsType
  @@options_types = {:multi_choices => 1, 
                     :single_choice => 2, 
                     :number => 3, 
                     :text => 4, 
                     :multi_choices_with_text => 5, 
                     :single_choice_with_text => 6,
                     :multi_choices_with_number => 7, 
                     :single_choice_with_number => 8,
                     :large_text => 9}
  
  def self.options_types
    @@options_types
  end
  
  def self.options_types_title
    titled = {}
    Survey::OptionsType.options_types.each{|k, v| titled[k.to_s.titleize] = v}
    titled
  end
  
  def self.options_type_ids
    @@options_types.values
  end
  
  def self.options_type_keys
    @@options_types.keys
  end
  
  @@options_types.each do |key, val|
    define_singleton_method "#{key}" do
        val
    end
  end
end