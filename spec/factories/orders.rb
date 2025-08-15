FactoryBot.define do
  factory :order do
    user { nil }
    status { "MyString" }
    subtotal { "9.99" }
    tax_amount { "9.99" }
    total { "9.99" }
    order_date { "2025-08-15 15:10:45" }
    billing_address { "MyText" }
  end
end
