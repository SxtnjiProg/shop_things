FactoryBot.define do
  factory :order do
    user { nil }
    status { "MyString" }
    total_price { "9.99" }
    street { "MyString" }
    city { "MyString" }
    zip_code { "MyString" }
    country { "MyString" }
  end
end
