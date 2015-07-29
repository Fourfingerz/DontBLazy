class AddQueueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :microposts_due_queue, :string
  end
end
