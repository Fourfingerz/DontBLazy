class Delayed::Job < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  attr_accessible :owner, :owner_type, :owner_id,
                  :priority, :payload_object, :run_at, :queue
end