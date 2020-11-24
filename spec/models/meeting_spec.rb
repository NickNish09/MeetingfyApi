require 'rails_helper'

RSpec.describe Meeting, type: :model do
  context 'model validations' do
    let(:date_aux) { DateTime.next.noon } # gets next monday by default
    it 'is valid with valid attributes' do
      meeting = build(:meeting)
      expect(meeting).to be_valid
    end

    it 'is not valid without a title' do
      meeting = build(:meeting, title: nil)
      expect(meeting).to_not be_valid
    end

    it 'is not valid without a start date' do
      meeting = build(:meeting, meeting_start: nil)
      expect(meeting).to_not be_valid
    end

    it 'is not valid without a end date' do
      meeting = build(:meeting, meeting_end: nil)
      expect(meeting).to_not be_valid
    end

    it 'is not valid with a start date greater then end date' do
      meeting = build(:meeting, meeting_start: date_aux + 1, meeting_end: date_aux)
      expect(meeting).to_not be_valid
    end

    it 'is not valid with a start date previous to now' do
      # trying to create a meeting for 2 hours ago
      meeting = build(:meeting, meeting_start: DateTime.now.advance(hours: -2), meeting_end: DateTime.now.advance(hours: -1))
      expect(meeting).to_not be_valid
    end

    it 'is not valid if datetime is not a commercial hour' do
      # trying to create a meeting for 2 hours ago
      meeting = build(:meeting, meeting_start: date_aux.advance(hours: 8), meeting_end: date_aux.advance(hours: 9)) # out of commercial time
      expect(meeting).to_not be_valid
    end
  end
end
