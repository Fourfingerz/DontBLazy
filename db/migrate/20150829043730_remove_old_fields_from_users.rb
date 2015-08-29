class RemoveOldFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :micropost_id_due_now, :integer
    remove_column :users, :microposts_due_queue, :string
  end
end
