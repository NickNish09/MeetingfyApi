require 'rails_helper'

RSpec.describe "V1::Meetings", type: :request do
  let(:auth_headers) {
    @user = create(:user)
    @user.create_new_auth_token
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

        it 'returns a error message' do
          expect(JSON.parse(response.body)['msg']).to eq 'Sala reservada para este horário.'
        end
      end

      context "when there are NO schedule conflicts" do
        before do
          date_aux = DateTime.now
          @room = create(:room)
          # creating a date with 3 hours range
          @meeting = create(:meeting, room: @room,
                            meeting_start: date_aux, meeting_end: date_aux.advance(hours: 3))
          # gets and interval that is outside the other meeting
          valid_params = {
            meeting_start: @meeting.meeting_start.advance(hours: 4),
            meeting_end: @meeting.meeting_start.advance(hours: 6),
            room_id: @room.id,
            title: "RENUT"
          }
          post v1_meetings_path, params: { meeting: valid_params }, headers: auth_headers, as: :json
        end

        it 'returns created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns the scheduled meeting' do
          expect(JSON.parse(response.body)['title']).to eq 'RENUT'
        end
      end

      context "with invalid params" do
        before do
          date_aux = DateTime.now
          @room = create(:room)
          invalid_params = {
              meeting_start: date_aux,
              meeting_end: date_aux.advance(hours: -1), # sending a meeting end previous to start
              room_id: @room.id,
              title: nil # without title
          }
          post v1_meetings_path, params: { meeting: invalid_params }, headers: auth_headers, as: :json
        end

        it 'returns unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['meeting_end']).to eq ["Fim da reunião deve ser depois do começo"]
          expect(JSON.parse(response.body)['title']).to eq ["can't be blank"]
        end
      end
    end
  end
end
