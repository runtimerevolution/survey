module <%= scope_module %>SurveysHelper
  def link_to_remove_field(name, f)
    f.hidden_field(:_destroy) +
    __link_to_function(raw(name), "removeField(this)", :id =>"remove-attach")
  end

  def new_survey
    new_<%= scope_namespace %>survey_path
  end

  def edit_survey(resource)
    edit_<%= scope_namespace %>survey_path(resource)
  end

  def survey_scope(resource)
    if action_name =~ /new|create/
      <%= scope_namespace %>surveys_path(resource)
    elsif action_name =~ /edit|update/
      <%= scope_namespace %>survey_path(resource)
    end
  end

  def new_attempt
    new_<%= scope_namespace %>attempt_path
  end

  def attempt_scope(resource)
    if action_name =~ /new|create/
     <%= scope_namespace %>attempts_path(resource)
    elsif action_name =~ /edit|update/
      <%= scope_namespace %>attempt_path(resource)
    end
  end

  def link_to_add_field(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,:child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    __link_to_function(name, "addField(this, \"#{association}\", \"#{escape_javascript(fields)}\")",
    :id=>"add-attach",
    :class=>"btn btn-small btn-info")
  end

  private

  def __link_to_function(name, on_click_event, opts={})
    link_to(name, '#', opts.merge(onclick: on_click_event))
  end
end
