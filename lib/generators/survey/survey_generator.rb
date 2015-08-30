module Survey
  class SurveyGenerator < Rails::Generators::Base

    source_root File.expand_path("../../templates", __FILE__)

    TEMPLATES = ["active_admin", "rails_admin", "plain", "routes"]

    argument  :arguments,
              :type => :array,
              :default => [],
              :banner => "< #{TEMPLATES.join("|")} > [options]"

    def create_resolution
      strategy = arguments.first
      if TEMPLATES.include? strategy
        send("generate_#{strategy}_resolution")
        success_message(strategy)
      else
        error_message(strategy)
      end
    end

    private

    def generate_active_admin_resolution
      copy_file "active_admin.rb", "app/admin/survey.rb"
    end

    def generate_rails_admin_resolution
      scope = get_scope
      copy_file "rails_admin.rb", "config/initializers/survey_rails_admin.rb"
      template "attempts_plain.rb", "app/controllers/attempts_controller.rb"
      template "helper.rb", "app/helpers/surveys_helper.rb"
      directory "attempts_views", "app/views/attempts", :recursive => true
      generate_routes_for(scope, true)
    end

    def generate_plain_resolution
      scope = get_scope
      prefix = scope ? "/#{scope}" : ""
      template "survey_plain.rb", "app/controllers#{prefix}/surveys_controller.rb"
      template "attempts_plain.rb", "app/controllers#{prefix}/attempts_controller.rb"
      template "helper.rb", "app/helpers#{prefix}/surveys_helper.rb"
      directory "survey_views", "app/views#{prefix}/surveys", :recursive => true
      directory "attempts_views", "app/views#{prefix}/attempts", :recursive => true
      generate_routes_for(scope)
    end

    def generate_routes_resolution
      generate_routes_for(get_scope)
    end

    # Error Handlers
    def error_message(argument)
      error_message = <<-CONTENT
        This Resolution: '#{argument}' is not supported by Survey:
        We only support Active Admin, Refinery and Active Scaffold
      CONTENT
      say error_message, :red
    end

    def success_message(argument)
      say "Generation of #{argument.capitalize} Template Complete :) enjoy Survey", :green
    end

    def generate_routes_for(namespace, conditional=nil)
      content_with_namespace = <<-CONTENT

  namespace :#{namespace} do
    resources :surveys
    resources :attempts, :only => [:new, :create]
  end
CONTENT

      content_without_namespace = <<-CONTENT

  resources :surveys
  resources :attempts, :only => [:new, :create]
CONTENT

      inject_into_file "config/routes.rb", "\n#{namespace ? content_with_namespace : content_without_namespace}",
        :after => "#{Rails.application.class.to_s}.routes.draw do"
    end

    def get_scope
      return nil if arguments.size == 1
      namespace = arguments[1].split(':')
      return namespace.last if namespace.size == 2 && namespace.first == 'namespace' && !namespace.blank?
      say("Wrong parameter name: use namespace:<name> instead.", :red)
      fail
    end

    def scope_module
      get_scope ? "#{get_scope.titleize}::" : ""
    end

    def scope_namespace
      get_scope ? "#{get_scope}_" : ""
    end

  end
end