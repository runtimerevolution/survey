# Questionaire

[![Code Climate](https://codeclimate.com/github/dr-click/survey.png)](https://codeclimate.com/github/dr-click/questionaire)
### questionaire on Rails...

Questionaire is a Rails Engine that brings multi types of quizzes, surveys and contests into your Rails
application. Questionaire models were designed to be flexible enough in order to be extended and
integrated with your own models. Questionaire was initially extracted from a real application that handles contests and quizzes.

## Documentation

You can view the Questionaire documentation in RDoc format here:

http://rubydoc.info/github/dr-click/questionaire/master/frames

## Main Features:
 - Questionaire can limit the number of attempts for each participant, can have multiple sections
 - Sections can have multiple questions
 - Questions can have multiple answers
 - Answers can have different weights and types (multi choices, single choice, number, text)
 - Can use 2 languages (Main language field, Localized field) for Surveys, Sections, Questions and Answers attributes
 - Base Scaffold Support for Active Admin, Rails Admin and default Rails Controllers
 - Base calculation for scores
 - Easy integration with your project

## Installation

Add survey to your Gemfile:
```ruby
gem 'questionaire', github: 'dr-click/questionaire', branch: 'master', :require=>"survey"

```
Then run bundle to install the Gem:
```sh
bundle install
```
Now generate and run migrations:
```sh
rails generate survey:install

bundle exec rake db:migrate
```

## Getting started with Survey

## Survey inside your models
To make a model aware of you just need to add `has_surveys` on it:
```ruby
class User < ActiveRecord::Base
  has_surveys

  #... (your code) ...
end
```
There is the concept of participant, in our example we choose the User Model.
Every participant can respond to surveys and every response is registered as a attempt.
By default, survey logic assumes an infinite number of attempts per participant
but if your surveys need to have a maximum number of attempts
you can pass the attribute `attempts_number` when creating them.
```ruby
# Each Participant can respond 4 times this survey
Survey::Survey.new(:name => "Star Wars Quiz", :attempts_number => 4)
```
## Questionaire used in your controllers
In this example we are using the current_user helper
but you can do it in the way you want.

```ruby
class ContestsController < ApplicationController

  helper_method :survey, :participant

  # create a new attempt to this survey
  def new
    @survey =  Survey::Survey.active.last
    @attempt = @survey.attempts.new
    @attempt.answers.build
    @participant = current_user # you have to decide what to do here
  end

  # create a new attempt in this survey
  # an attempt needs to have a participant assigned
  def create
    @survey = Survey::Survey.active.last
    @attempt = @survey.attempts.new(attempt_params)
    @attempt.participant = current_user
    if @attempt.valid? and @attempt.save
      redirect_to view_context.new_attempt_path, alert: I18n.t("attempts_controller.#{action_name}")
    else
      flash.now[:error] = @attempt.errors.full_messages.join(', ')
      render :action => :new
    end
  end
  
  #######
  private
  #######

  # Rails 4 Strong Params
  def attempt_params
    if Rails::VERSION::MAJOR < 4
      params[:survey_attempt]
    else
      params.require(:survey_attempt).permit(answers_attributes: [:id, :question_id, :option_id, :option_text, :option_number, :predefined_value_id, :_destroy, :finished])
    end
  end
  
end
```

## Survey inside your Views

### Controlling Survey avaliability per participant
To control which page participants see you can use method `avaliable_for_participant?`
that checks if the participant already spent his attempts.
```erb
<h3><%= flash[:alert]%></h3>
<h3><%= flash[:error]%></h3>

<% if @survey.avaliable_for_participant?(@participant) %>
  <%= render 'form' %>
<% else %>
  <p>
    <%= @participant.name %> spent all the possible attempts to answer this Survey
  </p>
<% end -%>

<% # in _form.html.erb %>
<h1><%= @survey.name %></h1>
<p><%= @survey.description %></p>
<%= form_for(@attempt, :url => attempt_scope(@attempt)) do |f| %>
  <%= f.fields_for :answers do |builder| %>
    <ul>
      <% seq = 0 %>
      <% @survey.sections.each do |section| %>
        <p><span><%= "#{section.head_number} : " if section.head_number %></span><%= section.name%></p>
        <p><%= section.description if section.description %></p>
        <% section.questions.each do |question| %>
          <% seq += 1 %>
          <li>
            <p><span><%= "#{question.head_number} : " if question.head_number %></span><%= question.text %></p>
            <p><%= question.description if question.description %></p>
            <% question.options.each do |option| %>
              
              
              <% if option.options_type_id == Survey::OptionsType.multi_choices %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][question_id]", question.id %>
                <%= check_box_tag "survey_attempt[answers_attributes][#{seq}][option_id]", option.id %>
                <% seq += 1 %>
              <% elsif option.options_type_id == Survey::OptionsType.single_choice %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][question_id]", question.id %>
                <%= radio_button_tag "survey_attempt[answers_attributes][#{seq}][option_id]", option.id %>
              <% elsif option.options_type_id == Survey::OptionsType.number %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][question_id]", question.id %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][option_id]", option.id %>
                <%= number_field_tag "survey_attempt[answers_attributes][#{seq}][option_number]", "", :style => "width: 40px;" %>
                <% seq += 1 %>
              <% elsif option.options_type_id == Survey::OptionsType.text %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][question_id]", question.id %>
                <%= hidden_field_tag "survey_attempt[answers_attributes][#{seq}][option_id]", option.id %>
                <%= text_field_tag "survey_attempt[answers_attributes][#{seq}][option_text]", "" %>
                <% seq += 1 %>
              <% end %>
              
              <%= option.text %> <br/>
            <% end -%>
          </li>
        <% end -%>
      <% end -%>
    </ul>
  <% end -%>
  <%= f.submit "Submit" %>
<% end -%>
```

### Scaffolds and CRUD frameworks
If you are using Rails Admin or Active Admin, you can generate base CRUD screens for Survey with:
```sh
rails generate survey active_admin

rails generate survey rails_admin
```
If you want a simple way to get started you can use the `plain` option which is a simple Rails scaffold to generate the controller and views related with survey logic.
By default when you type `rails g survey plain` it generates a controller in the `admin` namespace but you can choose your own namespace as well:
```sh
rails generate survey plain namespace:contests
```

By default when you generates your controllers using the `plain` command the task
generates the associated routes as well.
Afterwards if you want to generate more routes, you can using the command:

```sh
rails generate survey routes namespace:admin
```

## How to use it
Every user has a collection of attempts for each survey that he respond to. Is up to you to
make averages and collect reports based on that information.
What makes Survey useful is that all the logic behind surveys is now abstracted and well integrated,
making your job easier.

## Hacking with Survey through your Models:

```ruby
# select the first active Survey
survey = Survey::Survey.active.first

# select all the attempts from this survey
survey_answers = survey.attempts

# check the highest score for current user
user_highest_score  = survey_answers.for_participant(@user).high_score

#check the highest score made for this survey
global_highest_score = survey_answers.high_score
```
# Compability 
### Rails
Survey supports Rails 3 and 4. For use in Rails 4 without using protected_attributes gem.
Rails 4 support is recent, so some minor issues may still be present, please report them.

### Active Admin
Only support versions of Active Admin higher than 0.3.1.

# License
- Copyright © 2013 [Runtime Revolution](http://www.runtime-revolution.com), released under the MIT license.
- This repository was forked from the original one : https://github.com/runtimerevolution/survey
