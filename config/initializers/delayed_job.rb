class Delayed::Job < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  attr_accessible :owner, :owner_type, :owner_id
end