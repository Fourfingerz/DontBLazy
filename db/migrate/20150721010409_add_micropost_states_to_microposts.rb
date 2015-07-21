class AddMicropostStatesToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :days_completed, :integer
    add_column :microposts, :days_remaining, :integer
    add_column :microposts, :current_day, :integer
  end
end
