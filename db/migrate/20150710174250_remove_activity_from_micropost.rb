class RemoveActivityFromMicropost < ActiveRecord::Migration
  def change
    remove_column :microposts, :activity, :string
  end
end
