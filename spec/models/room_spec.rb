require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "#available?" do
    context "when the meeting_start is between other meeting schedule" do
      before do
        @date_aux = DateTime.now
        @room = create(:room)
        # creating a date with 3 hours range
        @meeting = create(:meeting, room: @room,
                          meeting_start: @date_aux, meeting_end: @date_aux.advance(hours: 3))
      end

      it 'returns false' do
        # advancing meeting_start in 1 hour to be between the meeting schedule
        expect(@room.available?(@date_aux.advance(hours: 1), @date_aux.advance(hours: 4))).to be_falsey
      end
    end

    context "when the meeting_end is between other meeting schedule" do
      before do
        @date_aux = DateTime.now
        @room = create(:room)
        # creating a date with 3 hours range
        @meeting = create(:meeting, room: @room,
                          meeting_start: @date_aux, meeting_end: @date_aux.advance(hours: 3))
      end

      it 'returns false' do
        # advancing meeting_start in 1 hour to be between the meeting schedule
        expect(@room.available?(@date_aux.advance(hours: 1), @date_aux.advance(hours: 2))).to be_falsey
      end
    end

    context "when start and end are not between other meeting schedule" do
      before do
        @date_aux = DateTime.now
        @room = create(:room)
        # creating a date with 3 hours range
        @meeting = create(:meeting, room: @room,
                          meeting_start: @date_aux, meeting_end: @date_aux.advance(hours: 3))
      end

      it 'returns true' do
        # advancing meeting_start in 1 hour to be between the meeting schedule
        expect(@room.available?(@date_aux.advance(hours: 4), @date_aux.advance(hours: 6))).to be_truthy
      end
    end
  end
  
  context 'model validations' do
    it 'is valid with valid attributes' do
      room = build(:room)
      expect(room).to be_valid
    end

    it 'is not valid without a name' do
      room = build(:room, name: nil)
      expect(room).to_not be_valid
    end

    it 'is not valid without a capability' do
      room = build(:room, capability: nil)
      expect(room).to_not be_valid
    end
  end
end
