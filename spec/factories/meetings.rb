FactoryBot.define do
  factory :meeting do
    association :room
    association :user
    meeting_start { DateTime.tomorrow.noon }
    meeting_end { DateTime.tomorrow.noon.advance(hours: 2) }
    title { "RENOE" }
  end
end
