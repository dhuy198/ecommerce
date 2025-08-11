class Card < ApplicationRecord
  belongs_to :user
  validates :stripe_card_id, presence: true
end
