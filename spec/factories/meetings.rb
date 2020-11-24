FactoryBot.define do
  factory :meeting do
    association :room
    association :user
    meeting_start { "2020-11-23 20:54:07" }
    meeting_end { "2020-11-23 22:54:07" }
    title { "RENOE" }
  end
end
