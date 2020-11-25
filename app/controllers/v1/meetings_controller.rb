module V1
  class MeetingsController < ApplicationController
    before_action :set_meeting, only: [:update, :destroy]
    before_action :require_user_authentication, only: [:create, :update, :destroy]
    before_action :require_owner, only: [:update, :destroy]

    def create
      @meeting = current_user.meetings.new(meeting_params)
      if @meeting.room.available?(@meeting.meeting_start, @meeting.meeting_end)
        if @meeting.save
          render json: @meeting, status: :created, location: [:v1, @meeting]
        else
          render json: @meeting.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Sala reservada para este horário.' }, status: :unprocessable_entity
      end
    end

    def update
      if @meeting.update(meeting_params)
        render json: @meeting
      else
        render json: @meeting.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render json: { msg: "Reunião deletada" }, status: :ok if @meeting.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def meeting_params
      params.require(:meeting).permit(:title, :meeting_start, :meeting_end, :user_id, :room_id)
    end

    def require_user_authentication
      render json: { error: 'você precisa estar autenticado ter acesso' }, status: :unauthorized unless user_signed_in?
    end

    def require_owner
      unless @meeting.user == current_user # if the current user owns the meeting, do nothing
        render json: { error: 'você precisa ser o organizador da reunião para alterá-la' }, status: :unauthorized
      end
    end
  end
end