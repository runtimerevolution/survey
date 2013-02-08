# Survey

### Surveys on Rails...

Survey is a Ruby Engine that brings quizzes, surveys and contests into your Rails
application. Survey models were designed to be flexible enough in order to easly be extended and
integrated with your own models. Survey Logic was firstly developed as a contest quiz.

## Main Features:
 - Surveys can limit the number of attempts for each participant
 - Questions can have multiple answers
 - Answers can have different weights
 - Base Scaffold Support for Active Admin, Rails Admin and default Rails Controllers
 - Base calculation for scores
 - Easy integration with your project

## Installation

Add survey to your Gemfile:
```ruby
gem 'survey'
```
Then run the bundle command:
```sh
bundle install
```
Now generate and run migrations:
```sh
rails generate survey:install

bundle exec rake db:migrate
```

## Getting Start with Survey

### Integrate Survey into your Rails App
There are three ways to install survey into your project.
If you are using Rails Admin or Active Admin Frameworks you can use this approach:
```sh
rails generate survey active_admin

rails generate survey rails_admin
```
If you want a simpler way in the integration proccess you can use the `plain` option which is a simple Rails scaffold to generate the controller and views related with survey logic.
By default when you type `rails g survey plain` it generates a controller in the `admin` namespace but you can choose your own namespace as well:
```sh
rails generate survey plain namespace:contests
```

## Survey inside your models
To tell that User model can answer to surveys you just need to add `has_surveys` on it:
```ruby
class User < ActiveRecord::Base
  has_surveys

  #... (your logic) ...
end
```
There is the concept of participant, in our example we choose the User Model.
Every participant can respond to surveys and every response is registered as a attempt.
By default, survey logic assumes infinity number of attempts per participant
but if your surveys need to have a maximum number of attempts
you can pass the attribute `attempts_number` in the creation of the it.
```ruby
# Each Participant can respond 4 times this survey
Survey::Survey.new(:name => "Star Wars Quiz", :attempts_number => 4)
```
## Surveys used in your controllers
In this example we are using the current_user helper
but you can do it in the way you want.

```ruby
class ContestsController < ApplicationController

  helper_method :survey, :participant

  # create a new attempt to this survey
  def new
    @attempt = survey.attempts.new
    # build a number of possible answers equal to the number of options
    survey.questions.size.times { @attempt.answers.build }
  end

  # create a new attempt in this survey
  # an attempt needs to have a participant assigned
  def create
    @attempt = survey.attempts.new(params[:attempt])
    # ensure that current user is assigned with this attempt
    @attempt.participant = participant
    if @attempt.valid? and @attempt.save
      redirect_to contests_path
    else
      render :action => :new
    end
  end

  def participant
    @participant ||= current_user
  end

  def survey
    @survey ||= Survey::Survey.active.first
  end
end
```

## Survey inside your Views

### Controlling the Survey Avaliability per Participant
To control which page participants see you can use method `avaliable_for_participant?`
that checks if the participant already spent his attempts.
```erb
<% if @survey.avaliable_for_participant?(@participant) %>
  <%= render 'form' %>
<% else %>
  Uupss, <%= @participant.name %> you have reach the maximum number of
  attempts for <%= @survey.name %>
<% end %>

<% # in _form.html.erb %>
<%= form_for [:contests, @attempt] do |f| %>
  <%= f.fields_for :answers do |builder| %>
    <ul>
      <% @survey.questions.each do |question| %>
        <li>
          <p><%= question.text %></p>
          <%= builder.hidden_field :question_id, :value => question.id %>
          <% question.options.each do |option| %>
            <%= builder.check_box :option_id, {}, option.id, nil %>
            <%= option.text %> <br/ >
          <% end -%>
        </li>
      <% end -%>
    </ul>
  <% end -%>
  <%= f.submit "Submit" %>
<% end -%>
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
# Compability Issues
### Active Admin
Only support versions of Active Admin higher than 0.3.1.

# RoadMap

- Add a form builder or a helper to improve the creation of Survey forms.
- Add polymorphic relations to help the survey to be extended with subclasses.
- Developer can add new fields without break the existent logic.

This project rocks and uses MIT-LICENSE.
