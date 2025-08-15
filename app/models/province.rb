# app/models/province.rb

class Province < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :orders, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_tax_rate
    hst_rate > 0 ? hst_rate : (gst_rate + pst_rate)
  end

  def tax_breakdown
    if hst_rate > 0
      { hst: hst_rate }
    else
      taxes = {}
      taxes[:gst] = gst_rate if gst_rate > 0
      taxes[:pst] = pst_rate if pst_rate > 0
      taxes
    end
  end
end