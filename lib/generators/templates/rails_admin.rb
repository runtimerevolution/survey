RailsAdmin.config do |c|
  c.model 'Survey::Answer' do
    visible false
  end

  c.model 'Survey::Option' do
    visible false
  end

  c.model 'Survey::Attempt' do
    visible false
  end

  c.model 'Survey::Question' do
    visible false
  end
end