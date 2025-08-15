# app/models/user.rb

class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :orders, dependent: :destroy
  belongs_to :province, optional: true

  # Validations (Feature 4.2.1 ✯)
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone, presence: true, format: { with: /\A[\+]?[1-9][\d\s\-\(\)]{7,}\z/, message: "Invalid phone format" }
  
  # Address validations (will be required during checkout)
  validates :address_line_1, presence: true, if: :address_required?
  validates :city, presence: true, if: :address_required?
  validates :postal_code, presence: true, format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/ }, if: :address_required?

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    return "No address provided" unless address_complete?
    
    address = address_line_1
    address += ", #{address_line_2}" if address_line_2.present?
    address += ", #{city}, #{province.name} #{postal_code}" if province
    address
  end

  def address_complete?
    address_line_1.present? && city.present? && postal_code.present? && province_id.present?
  end

  private

  def address_required?
    # Address will be required during checkout, but not for registration
    false
  end
end