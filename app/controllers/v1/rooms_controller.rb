module V1
  class RoomsController < ApplicationController
    before_action :set_room, only: [:show, :update, :destroy]
    before_action :require_user_authentication, only: [:create, :update, :destroy]

    # GET /v1/rooms
    def index
      @rooms = Room.all

      render json: @rooms
    end

    # GET /v1/rooms/1
    def show
      render json: @room
    end

    # POST /v1/rooms
    def create
      @room = Room.new(room_params)

      if @room.save
        render json: @room, status: :created, location: [:v1, @room]
      else
        render json: @room.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/rooms/1
    def update
      if @room.update(room_params)
        render json: @room
      else
        render json: @room.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/rooms/1
    def destroy
      @room.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def room_params
      params.require(:room).permit(:name, :capability)
    end

    def require_user_authentication
      unless user_signed_in?
        render json: { error: 'você precisa estar autenticado ter acesso' }, status: :unauthorized
      end
    end
  end

end