require 'rails_helper'

RSpec.describe Room, type: :model do
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
