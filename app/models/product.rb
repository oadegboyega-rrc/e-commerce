class Product < ApplicationRecord
    #Active Storage for images
    has_many_attached :images

    #Validations
    validates :name, presence: true, length: {minimum: 2, maximum: 100}
    validates :description, presence: true, length: {minimum: 10}
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :category, presence: true

    #Scopes for filtering
    scope :on_sale, -> { where(on_sale: true) }
    scope :new_arrivals, -> { where(new_arrival: true) }
    scope :recently_updated, -> { where('updated_at > ?', 1.week.ago) }

    #Search functionality
    scope :search_by_keyword, ->(keyword) {
        where('name ILIKE ? OR description ILIKE ?', "%#{keyword}%", "%#{keyword}%")
    }

    scope :by_category, ->(category) {
        where(category: category) if category.present?
    }

    # Ransack allowlist for ActiveAdmin
    def self.ransackable_attributes(auth_object = nil)
        [
            "id", "name", "description", "price", "category", "on_sale", "new_arrival", "created_at", "updated_at"
        ]
    end
end
