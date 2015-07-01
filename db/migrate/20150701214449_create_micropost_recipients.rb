class CreateMicropostRecipients < ActiveRecord::Migration
  def change
    create_table :micropost_recipients do |t|
      t.integer :micropost_id
      t.integer :recipient_id

      t.timestamps null: false
    end
  end
end
