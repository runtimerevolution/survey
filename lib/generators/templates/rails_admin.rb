RailsAdmin.config do |c|
  c.excluded_models = [
    Survey::Answer,
    Survey::Option,
    Survey::Attempt,
    Survey::Question
  ]
end