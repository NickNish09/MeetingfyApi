require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "V1::Rooms", type: :request do
  let(:valid_headers) {
    {}
  }

  let(:auth_headers) {
    @user = create(:user)
    @user.create_new_auth_token
  }

  let(:valid_attributes) {
    {
      name: "Sala Pequena",
      capability: 10
    }
  }

  let(:invalid_attributes) {
    {
      name: nil
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      create(:room)
      get v1_rooms_path, headers: valid_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    before do
      room = create(:room_with_meetings)
      get v1_room_url(room), as: :json
    end

    it "renders a successful response" do
      expect(response).to have_http_status(:success)
    end

    it 'returns the meetings for that room' do
      expect(JSON.parse(response.body)['meetings']).to_not be_nil
      expect(JSON.parse(response.body)['meetings'].length).to eq 3
    end
  end

  describe "POST /create" do
    context "with user authenticated" do
      context "with valid parameters" do
        it "creates a new Room" do
          expect {
            post v1_rooms_url,
                 params: { room: valid_attributes }, headers: auth_headers, as: :json
          }.to change(Room, :count).by(1)
        end

        it "renders a JSON response with the new room" do
          post v1_rooms_url,
               params: { room: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['name']).to eq valid_attributes[:name]
          expect(JSON.parse(response.body)['capability']).to eq valid_attributes[:capability]
        end
      end

      context "with invalid parameters" do
        it "does not create a new Room" do
          expect {
            post v1_rooms_url,
                 params: { room: invalid_attributes }, headers: auth_headers, as: :json
          }.to change(Room, :count).by(0)
        end

        it "renders a JSON response with errors for the new room" do
          post v1_rooms_url,
               params: { room: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "without user authenticated" do
      it "does not create a new Room" do
        expect {
          post v1_rooms_url,
               params: { room: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Room, :count).by(0)
      end

      it "returns unauthorized" do
        post v1_rooms_url,
             params: { room: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it "renders a JSON response with authentication errors" do
        post v1_rooms_url,
             params: { room: valid_attributes }, headers: valid_headers, as: :json
        expect(JSON.parse(response.body)['error']).to eq('você precisa estar autenticado ter acesso')
      end
    end
  end

  describe "PATCH /update" do
    context "with user authenticated" do
      context "with valid parameters" do
        let(:new_attributes) {
          {name: 'Novo Nome', capability: 15}
        }

        it "updates the requested v1_room" do
          room = create(:room)
          patch v1_room_url(room),
                params: { room: new_attributes }, headers: auth_headers, as: :json
          room.reload
          expect(room.name).to eq 'Novo Nome'
          expect(room.capability).to eq 15
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the v1_room" do
          room = create(:room)
          patch v1_room_url(room),
                params: { room: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "without user authenticated" do
      before do
        @room = create(:room)
      end
      it "returns unauthorized" do
        patch v1_room_url(@room),
              params: { room: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it "renders a JSON response with authentication errors" do
        patch v1_room_url(@room),
              params: { room: valid_attributes }, headers: valid_headers, as: :json
        expect(JSON.parse(response.body)['error']).to eq('você precisa estar autenticado ter acesso')
      end
    end
  end

  describe "DELETE /destroy" do
    context "with user authenticated" do
      it "destroys the requested v1_room" do
        room = create(:room)
        expect {
          delete v1_room_url(room), headers: auth_headers, as: :json
        }.to change(Room, :count).by(-1)
      end
    end

    context "without user authenticated" do
      before do
        @room = create(:room)
      end

      it "returns unauthorized" do
        delete v1_room_url(@room), headers: valid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it "does not change the rooms count" do
        expect {
          delete v1_room_url(@room), headers: valid_headers, as: :json
        }.to change(Room, :count).by(0)
      end
    end
  end
end
