class AddLateButCurrentToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :late_but_current, :boolean
  end
end
