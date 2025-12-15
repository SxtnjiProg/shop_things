FactoryBot.define do
  factory :product do
    name { "MyString" }
    price { "9.99" }
    description { "MyText" }
    category { "MyString" }
    image { "MyString" }
    stock { 1 }
  end
end
