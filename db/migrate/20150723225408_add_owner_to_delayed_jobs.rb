class AddOwnerToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :owner_type, :string
    add_column :delayed_jobs, :owner_id, :integer

    add_index :delayed_jobs, [:owner_type, :owner_id]
  end
end
