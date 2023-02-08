# frozen_string_literal: true

# Module SurveysHelper
module <%= scope_module %>SurveysHelper
  SURVEY_TYPES = { 0 => 'quiz',
                   1 => 'score',
                   2 => 'poll' }.freeze

  def link_to_remove_field(name, field)
    field.hidden_field(:_destroy) +
      __link_to_function(raw(name), 'removeField(this)', id: 'remove-attach')
  end

  def new_survey
    new_<%= scope_namespace %>survey_path
  end

  def edit_survey(resource)
    edit_<%= scope_namespace %>survey_path(resource)
  end

  def survey_scope(resource)
    case action_name
    when /new|create/
      <%= scope_namespace %>surveys_path(resource)
    when /edit|update/
      <%= scope_namespace %>survey_path(resource)
    end
  end

  def new_attempt
    new_<%= scope_namespace %>attempt_path
  end

  def attempt_scope(resource)
    case action_name
    when /new|create/
      <%= scope_namespace %>attempts_path(resource)
    when /edit|update/
      <%= scope_namespace %>attempt_path(resource)
    end
  end

  def link_to_add_field(name, fld, association)
    new_object = fld.object.class.reflect_on_association(association).klass.new
    fields = fld.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
    __link_to_function(name, "addField(this, \"#{association}\", \"#{escape_javascript(fields)}\")",
                       id: 'add-attach',
                       class: 'btn btn-small btn-info')
  end

  private

  def __link_to_function(name, on_click_event, opts = {})
    link_to(name, '#', opts.merge(onclick: on_click_event))
  end
end
