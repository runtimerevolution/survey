class AddHeadNumberToOptionsTable < ActiveRecord::Migration
  def change
    #Survey Options table
    add_column :survey_options, :head_number, :string
  end
end
