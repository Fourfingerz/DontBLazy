class AddDaysToCompleteToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :days_to_complete, :integer
  end
end
