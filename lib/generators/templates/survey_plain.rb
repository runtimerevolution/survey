class <%= get_scope.capitalize %>::SurveysController < ApplicationController
  before_filter :load_survey, :only => [:show, :edit, :update]

  def index
    @surveys = Survey::Survey.all
  end

  def new
    @survey = Survey::Survey.new
  end

  def create
    @survey = Survey::Survey.new(survey_params)
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
    if @survey.update_attributes(survey_params)
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
  
  #######
  private
  #######

  # Rails 4 Strong Params
  def survey_params
    protected_attrs =  ["created_at", "updated_at"]
    params.require(:survey_survey).permit(Survey::Survey.new.attributes.keys - protected_attrs, 
                                          sections_attributes: Survey::Section.new.attributes.keys - protected_attrs,
                                          questions_attributes: Survey::Question.new.attributes.keys - protected_attrs)
  end
end