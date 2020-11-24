FactoryBot.define do
  factory :meeting do
    association :room
    association :user
    meeting_start { DateTime.now.advance(hours: 1) }
    meeting_end { DateTime.now.advance(hours: 2) }
    title { "RENOE" }
  end
end
