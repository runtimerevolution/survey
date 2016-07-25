# Survey

[![Build Status](https://travis-ci.org/runtimerevolution/survey.png?branch=master)](https://travis-ci.org/runtimerevolution/survey)
[![Code Climate](https://codeclimate.com/github/runtimerevolution/survey.png)](https://codeclimate.com/github/runtimerevolution/survey)
### Surveys on Rails...

Survey is a Rails Engine that brings quizzes, surveys and contests into your Rails
application. Survey models were designed to be flexible enough in order to be extended and
integrated with your own models. Survey was initially extracted from a real application that handles contests and quizzes.

## Documentation

You can view the Survey documentation in RDoc format here:

http://rubydoc.info/github/runtimerevolution/survey/frames

## Demo App

We have implemented a demo app for you to try out: [Demo App](http://survey-demo.herokuapp.com/surveys)

Here is the repository: https://github.com/runtimerevolution/survey-demo

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
gem "survey", "~> 0.1"
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
Survey::Survey.new(:name => "Star Wars Quiz", :description => "A quiz about Star Wars", :attempts_number => 4)
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

### Controlling Survey availability per participant
NOTE: avaliable_for_participant? method has been deprecated. Please use
available_for_participant? method instead.

To control which page participants see you can use method `available_for_participant?`
that checks if the participant already spent his attempts.
```erb
<% if @survey.available_for_participant?(@participant) %>
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
Every user has a collection of attempts for each survey that they can respond to. Is up to you to
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
Survey supports Rails 3 and 4. For use in Rails 4. Rails 4 support is recent, so some minor issues may still be present,
please report them.

### Active Admin
Only support versions of Active Admin higher than 0.3.1.

# Roadmap

- Add a form builder or a helper to improve the creation of Survey forms.
- Add polymorphic relations to help the survey be extended with subclasses.
- Allow adding new fields without breaking the existent logic.

# License
Copyright © 2013 [Runtime Revolution](http://www.runtime-revolution.com), released under the MIT license.
