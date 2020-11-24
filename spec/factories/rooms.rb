FactoryBot.define do
  factory :room do
    name { "Sala de Reunião Grande" }
    capability { 10 }

    # factory for creating room with some meetings already created
    factory :room_with_meetings do
      transient do
        meetings_count { 3 }
      end

      after(:create) do |room, evaluator|
        create_list(:meeting, evaluator.meetings_count, room: room) do |meeting, i|
          meeting.meeting_start = DateTime.next.noon + i.hours
          meeting.meeting_end = DateTime.next.noon + (i + 1).hours
        end
        room.reload
      end
    end
  end
end
