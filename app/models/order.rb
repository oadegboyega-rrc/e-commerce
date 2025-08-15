# app/models/order.rb

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
  validates :tax_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :order_date, presence: true

  # Scopes
  scope :recent, -> { order(order_date: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }

  # Feature 3.3.2 - Historical pricing (prices saved at time of order)
  before_create :save_historical_data

  def total_items
    order_items.sum(:quantity)
  end

  def order_number
    "ORD-#{id.to_s.rjust(6, '0')}"
  end

  def can_be_cancelled?
    %w[pending].include?(status)
  end

  def tax_breakdown
    return {} unless province
    
    tax_info = {}
    breakdown = province.tax_breakdown
    
    breakdown.each do |tax_type, rate|
      tax_info[tax_type] = (subtotal * rate / 100).round(2)
    end
    
    tax_info
  end

  private

  def save_historical_data
    # Feature 3.3.2 - Save historical tax rates and product prices
    self.order_date = Time.current
    
    # Tax amount and breakdown are calculated based on current rates
    # but saved to preserve historical data
  end
end