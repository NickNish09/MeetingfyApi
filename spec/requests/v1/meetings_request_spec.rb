require 'rails_helper'

RSpec.describe "V1::Meetings", type: :request do
  let(:auth_headers) {
    @user = create(:user)
    @user.create_new_auth_token
  }

  let(:date_aux) { DateTime.next.noon } # gets next monday by default

  describe "POST /create" do
    context "with user authenticated" do
      context "when there are schedule conflicts" do
        before do
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

    context "without user authenticated" do
      before do
        @room = create(:room)
        valid_params = {
          meeting_start: date_aux,
          meeting_end: date_aux.advance(hours: 1),
          room_id: @room.id,
          title: "RENOE" # without title
        }
        post v1_meetings_path, params: { meeting: valid_params }, headers: {}, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq "você precisa estar autenticado ter acesso"
      end
    end
  end

  describe "PUT /update" do
    context "with user authenticated" do
      context "when user owns the meeting" do
        context "with valid params" do
          before do
            @user = create(:user)
            @meeting = create(:meeting, user: @user)
            valid_params = {
                meeting_start: @meeting.meeting_start.advance(hours: 2),
                meeting_end: @meeting.meeting_start.advance(hours: 4), # reschedule for 2 hours later
                title: "RENOE MODIFICADA"
            }
            put v1_meeting_path(@meeting), params: { meeting: valid_params }, headers: @user.create_new_auth_token, as: :json
          end

          it 'returns ok status' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns the updated meeting' do
            expect(JSON.parse(response.body)['title']).to eq "RENOE MODIFICADA"
          end
        end

        context "with invalid parameters" do
          before do
            @user = create(:user)
            @meeting = create(:meeting, user: @user)
            invalid_params = {
                meeting_start: @meeting.meeting_start.advance(hours: 2),
                meeting_end: @meeting.meeting_start.advance(hours: -2), # sending meeting end previous to start
                title: nil # without title
            }
            put v1_meeting_path(@meeting), params: { meeting: invalid_params }, headers: @user.create_new_auth_token, as: :json
          end

          it 'returns unprocessable status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns an error message' do
            expect(JSON.parse(response.body)['title']).to eq ["can't be blank"]
            expect(JSON.parse(response.body)['meeting_end']).to eq ["Fim da reunião deve ser depois do começo"]
          end
        end
      end

      context "when user does no own the meeting" do
        before do
          @user = create(:user)
          @other_user = create(:user)
          @meeting = create(:meeting, user: @user)
          valid_params = {
              meeting_start: @meeting.meeting_start.advance(hours: 2),
              meeting_end: @meeting.meeting_start.advance(hours: 4), # reschedule for 2 hours later
              title: "RENOE MODIFICADA" # without title
          }
          # sends the request with other user headers
          put v1_meeting_path(@meeting), params: { meeting: valid_params }, headers: @other_user.create_new_auth_token, as: :json
        end

        it 'returns unauthorized status' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns the updated meeting' do
          expect(JSON.parse(response.body)['error']).to eq "você precisa ser o organizador da reunião para alterá-la"
        end
      end
    end

    context "without user authenticated" do
      before do
        @room = create(:room)
        @meeting = create(:meeting, room: @room)
        valid_params = {
            meeting_start: @meeting.meeting_start.advance(hours: 2),
            meeting_end: @meeting.meeting_start.advance(hours: 4), # reschedule for 2 hours later
            title: "RENOE MODIFICADA" # without title
        }
        put v1_meeting_path(@meeting), params: { meeting: valid_params }, headers: {}, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq "você precisa estar autenticado ter acesso"
      end
    end
  end

  describe "DELETE /destroy" do
    context "with user authenticated" do
      context "when user owns the meeting" do
        before do
          @user = create(:user)
          @meeting = create(:meeting, user: @user)
        end

        it 'returns ok status' do
          delete v1_meeting_path(@meeting), headers: @user.create_new_auth_token, as: :json
          expect(response).to have_http_status(:ok)
        end

        it 'destroy the meeting' do
          expect {
            delete v1_meeting_path(@meeting), headers: @user.create_new_auth_token, as: :json
          }.to change(Meeting, :count).by(-1)
        end

        it 'returns a success message' do
          delete v1_meeting_path(@meeting), headers: @user.create_new_auth_token, as: :json
          expect(JSON.parse(response.body)['msg']).to eq "Reunião deletada"
        end
      end
    end

    context "without user authenticated" do
      before do
        @meeting = create(:meeting)
        delete v1_meeting_path(@meeting), headers: {}, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq "você precisa estar autenticado ter acesso"
      end
    end
  end
end
