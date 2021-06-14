class User < ApplicationRecord
  validates :line_id, presence: true

  has_many :items
end
