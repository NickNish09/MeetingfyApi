FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.first_name }
    password { "123456" }
  end
end