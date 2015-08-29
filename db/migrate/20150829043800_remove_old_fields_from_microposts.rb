class RemoveOldFieldsFromMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :late_but_current, :boolean
  end
end
