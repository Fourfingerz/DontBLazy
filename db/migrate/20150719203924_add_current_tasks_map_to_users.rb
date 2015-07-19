class AddCurrentTasksMapToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_tasks_map, :text
  end
end
