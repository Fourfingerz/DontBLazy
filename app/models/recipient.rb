class Recipient < ActiveRecord::Base
  belongs_to :user
  has_many :micropost_recipients, dependent: :destroy
  has_many :microposts, through: :micropost_recipients
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :phone, presence: true, length: { minimum: 8, maximum: 25 },
                    uniqueness: { case_sensitive: false }
  validates :user_id, presence: true
end
