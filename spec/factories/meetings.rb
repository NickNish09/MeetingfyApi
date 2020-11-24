FactoryBot.define do
  factory :meeting do
    association :room
    association :user
    meeting_start { DateTime.next.noon }
    meeting_end { DateTime.next.noon.advance(hours: 2) }
    title { "RENOE" }
  end
end
