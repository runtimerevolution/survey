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
      copy_file "rails_admin.rb", "config/initializers/survey_rails_admin.rb"
    end

    def generate_plain_resolution
      scope = get_scope
      template "survey_plain.rb", "app/controllers/#{scope}/surveys_controller.rb"
      template "attempts_plain.rb", "app/controllers/#{scope}/attempts_controller.rb"
      template "helper.rb", "app/helpers/#{scope}/surveys_helper.rb"
      directory "survey_views", "app/views/#{scope}/surveys", :recursive => true
      directory "attempts_views", "app/views/#{scope}/attempts", :recursive => true
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
      content = <<-CONTENT

  namespace :#{namespace} do
    resources :surveys
    resources :attempts, :only => [:new, :create]
  end
CONTENT
       inject_into_file "config/routes.rb", "\n#{content}",
            :after => "#{Rails.application.class.to_s}.routes.draw do"
    end

    def get_scope
      arguments.size == 1 ? "admin" : arguments[1].split(":").last
    end

  end
end