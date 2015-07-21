class AddDueNowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :micropost_id_due_now, :integer
  end
end
