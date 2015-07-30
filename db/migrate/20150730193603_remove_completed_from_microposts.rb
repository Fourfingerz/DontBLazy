class RemoveCompletedFromMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :completed, :boolean
  end
end
