class <%= get_scope.capitalize %>::AttemptsController < ApplicationController

  helper "<%= get_scope%>/surveys"

  def new
    @survey =  Survey::Survey.active.first
    @attempt = @survey.attempts.new
    @attempt.answers.build
    @participant = current_user # you have to decide what to do here
  end

  def create
    @survey = Survey::Survey.active.first
    survey_attempt_params = Marshal.load( Marshal.dump(params[:survey_attempt]) )
    normalize_attempts_data(survey_attempt_params[:answers_attributes])
    @attempt = @survey.attempts.new(survey_attempt_params)
    @attempt.participant = current_user
    if @attempt.valid? and @attempt.save
      redirect_to view_context.new_attempt_path, alert: I18n.t("attempts_controller.#{action_name}")
    else
      render :action => :new
    end
  end

  private

  def normalize_attempts_data(hash)
    multiple_answers = []
    last_key = hash.keys.last.to_i

    hash.keys.each do |k|
      if hash[k]['option_id'].is_a?(Array)
        if hash[k]['option_id'].size == 1
          hash[k]['option_id'] = hash[k]['option_id'][0]
          next
        else
          multiple_answers <<  k if hash[k]['option_id'].size > 1
        end
      end
    end

    multiple_answers.each do |k|
      hash[k]['option_id'][1..-1].each do |o|
        last_key += 1
        hash[last_key.to_s] = hash[k].merge('option_id' => o)
      end
      hash[k]['option_id'] = hash[k]['option_id'].first
    end
  end

end