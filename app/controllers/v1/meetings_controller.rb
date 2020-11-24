module V1
  class MeetingsController < ApplicationController
    before_action :set_meeting, only: [:update, :destroy]
    def create
      @meeting = current_user.meetings.new(meeting_params)
      if @meeting.room.available?(@meeting.meeting_start, @meeting.meeting_end)
        if @meeting.save
          render json: @meeting, status: :created, location: [:v1, @meeting]
        else
          render json: @meeting.errors, status: :unprocessable_entity
        end
      else
        render json: {msg: 'Sala reservada para este horário.'}, status: :unprocessable_entity
      end
    end

    def update

    end

    def destroy

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
  end
end