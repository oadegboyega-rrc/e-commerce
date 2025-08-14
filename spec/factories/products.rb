FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    price { "9.99" }
    category { "MyString" }
    on_sale { false }
    new_arrival { false }
  end
end
