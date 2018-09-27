FactoryBot.define do
  factory :post do
    user { nil }
    title { "MyString" }
    content { "MyText" }
    user_ip { "127.0.0.1" }
  end
end
