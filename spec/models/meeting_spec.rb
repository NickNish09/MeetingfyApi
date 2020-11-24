require 'rails_helper'

RSpec.describe Meeting, type: :model do
  context 'model validations' do
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
      date_aux = DateTime.now
      meeting = build(:meeting, meeting_start: date_aux + 1, meeting_end: date_aux)
      expect(meeting).to_not be_valid
    end
  end
end
