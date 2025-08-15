# app/models/order_item.rb

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def total_price
    quantity * price
  end

  # Feature 3.3.2 - Save product price at time of order
  before_create :save_current_price

  private

  def save_current_price
    self.price = product.price if price.blank?
  end
end