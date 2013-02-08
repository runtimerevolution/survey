class <%= get_scope.capitalize %>::AttemptsController < ApplicationController

  helper "<%= get_scope%>/surveys"

  def new
    @survey =  Survey::Survey.active.first
    @attempt = @survey.attempts.new
    @survey.questions.size.times { @attempt.answers.build }
    @participant = current_user # you have to decide what to here
  end

  def create
    @survey = Survey::Survey.active.first
    @attempt = @survey.attempts.new(params[:attempt])
    @attempt.participant = current_user
    if @attempt.valid? and @attempt.save
      redirect_to root_path, alert: I18n.t("attempts_controller.#{action_name}")
    else
      render :action => :new
    end
  end

end