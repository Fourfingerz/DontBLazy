class MicropostRecipient < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :recipient 
  validates :micropost_id, presence: true
  validates :recipient_id, presence: true
end
