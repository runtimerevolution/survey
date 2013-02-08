ActiveAdmin.register Survey::Survey do
  menu :label => I18n.t("surveys")

  filter  :name,
          :as => :select,
          :collection => proc {
              Survey::Survey.select("distinct(name)").collect { |c|
                [c.name, c.name]
              }
          }
  filter :active,
         :as => :select,
         :collection => ["true", "false"]

  filter :created_at

  index do
    column :name
    column :description
    column :active
    column :attempts_number
    column :finished
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs I18n.t("survey_details") do
      f.input  :name
      f.input  :description
      f.input  :active, :as => :select, :collection => ["true", "false"]
      f.input  :attempts_number
    end
    f.inputs I18n.t("questions") do
      f.has_many :questions do |q|
        q.input :text
        q.has_many :options do |a|
          a.input  :text
          a.input  :correct
        end
      end
    end
    f.buttons
  end

end