class Room < ApplicationRecord
  validates :name, :capability, presence: true
end
