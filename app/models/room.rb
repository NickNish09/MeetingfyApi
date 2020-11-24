class Room < ApplicationRecord
  validates :name, :capability, presence: true
  has_many :meetings

  # returns true if the room is available for that range of times
  def available?(meeting_start, meeting_end)
    # if for any meeting schedule for the room, start/end is between them, return false
    meetings.each do |meeting|
      return false if meeting_start.between?(meeting.meeting_start, meeting.meeting_end)
      return false if meeting_end.between?(meeting.meeting_start, meeting.meeting_end)
    end

    # if there are no schedule conflicts, return true
    true
  end
end
