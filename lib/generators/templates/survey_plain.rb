<% if get_scope %>
module <%= get_scope.capitalize %>
<% end  %>
  class SurveysController < ApplicationController

      before_filter :load_survey, :only => [:show, :edit, :update]

      def index
        @surveys = Survey::Survey.all
      end

      def new
        @survey = Survey::Survey.new
      end

      def create
        @survey = Survey::Survey.new(params[:survey_survey])
        if @survey.valid? and @survey.save
          default_redirect
        else
          render :action => :new
        end
      end

      def edit
      end

      def show
      end

      def update
        if @survey.update_attributes(params[:survey_survey])
          default_redirect
        else
          render :action => :edit
        end
      end

      private

      def default_redirect
        redirect_to <%= get_scope %>_surveys_path, alert: I18n.t("surveys_controller.#{action_name}")
      end

      def load_survey
        @survey = Survey::Survey.find(params[:id])
      end

    end

  end
<% if get_scope %>
end
<% end  %>

