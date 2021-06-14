class Item < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :price, presence: true
  validates :user_id, presence: true

  belongs_to :user
end
