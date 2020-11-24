require 'rails_helper'

RSpec.describe "V1::Meetings", type: :request do
  let(:auth_headers) {
    @user = create(:user)
    @user.create_new_auth_token
  }

  let(:valid_attributes) {
    {
      meeting_start: DateTime.middle_of_day + 1,
      meeting_end: (DateTime.middle_of_day + 1).advance(hours: 2),
      title: "RENDP"
    }
  }

  describe "POST /create" do
    context "with user authenticated" do
      context "when there are schedule conflicts" do
        before do
          date_aux = DateTime.now
          @room = create(:room)
          # creating a date with 3 hours range
          @meeting = create(:meeting, room: @room,
                            meeting_start: date_aux, meeting_end: date_aux.advance(hours: 3))
          # gets and interval that is inside the other meeting
          conflict_params = {
              meeting_start: @meeting.meeting_start.advance(hours: 1),
              meeting_end: @meeting.meeting_start.advance(hours: 3),
              room_id: @room.id,
              title: "RENUT"
          }
          post v1_meetings_path, params: { meeting: conflict_params }, headers: auth_headers, as: :json
        end

        it 'returns unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
