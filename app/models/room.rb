class Room < ApplicationRecord
  validates :name, :capability, presence: true

  # returns true if the room is available for that range of times
  def available?(meeting_start, meeting_end)

  end
end
