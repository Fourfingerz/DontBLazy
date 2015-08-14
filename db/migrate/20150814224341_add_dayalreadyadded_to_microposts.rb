class AddDayalreadyaddedToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :day_already_completed, :boolean
  end
end
