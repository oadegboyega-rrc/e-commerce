# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Ensure admin@example.com exists
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
end if Rails.env.development?

# Ensure admin@email.com exists
AdminUser.find_or_create_by!(email: 'admin@email.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
end if Rails.env.development?

puts "Admin users created: admin@example.com, admin@email.com / password"

# Create Canadian Provinces with correct tax rates (Feature 3.2.3)
provinces_data = [
  { name: 'Alberta', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'British Columbia', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'Manitoba', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'New Brunswick', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Newfoundland and Labrador', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Northwest Territories', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Nova Scotia', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Nunavut', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Ontario', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 13.0 },
  { name: 'Prince Edward Island', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Quebec', gst_rate: 5.0, pst_rate: 9.975, hst_rate: 0.0 },
  { name: 'Saskatchewan', gst_rate: 5.0, pst_rate: 6.0, hst_rate: 0.0 },
  { name: 'Yukon', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by(name: province_data[:name]) do |province|
    province.assign_attributes(province_data)
  end
end

puts "Canadian provinces and tax rates created!"

# Add 24 more products for pagination test

require 'open-uri'
adjectives = %w[Cool Smart Fast Bright Fresh Modern Classic Trendy Sleek Compact]
nouns = %w[Speaker Watch Lamp Chair Table Phone Book Toy Mixer Headset]

24.times do |i|
    name = "#{adjectives.sample} #{nouns.sample} #{rand(100..999)}"
    product = Product.create!(
        name: name,
        description: "#{name} is a great product for your needs. Randomly generated for testing.",
        price: rand(10..100),
        category: ["Books", "Electronics", "Clothing", "Home", "Toys"].sample,
        on_sale: [true, false].sample,
        new_arrival: [true, false].sample
    )
    # Attach a resized placeholder image as thumbnail
    unless product.images.attached?
        file = URI.open("https://picsum.photos/seed/#{product.id}/80/80")
        product.images.attach(io: file, filename: "thumb-#{product.id}.jpg")
        puts "Attached thumbnail image for #{product.name}"
    end
end


#Create sample products 
products = [
    {
        name: "MacBook Pro 14-inch",
        description: "This MacBook Pro 14-inch delivers exceptional performance with the M2 Pro chip, featuring a stunning Liquid retina XDR display, and all-day battery life.",
        price: 2499.00,
        category: "Electronics",
        on_sale: true, 
        new_arrival: true
    },
    {
        name: "Nike Air Max 270",
        description: "Experience comfort and style with the Nike Air Max 270, featuring a large Air unit for cushioning and a sleek design.",
        price: 150.00,
        category: "Sport",
        on_sale: true,
        new_arrival: false
    },
    {
        name: "The Great Gatsby",
        description: "A classic novel by F. Scott Fitzgerald that explores themes of decadence, idealism, and social upheaval in 1920s America.",
        price: 10.99,
        category: "Books",
        on_sale: false,
        new_arrival: false
    },
    {
        name: "Instant Pot Duo 7-in-1",
        description: "The Instant Pot Duo is a versatile kitchen appliance that combines seven functions in one, including pressure cooking, slow cooking, and rice cooking.",
        price: 89.99,
        category: "Home",
        on_sale: true,  
        new_arrival: false
    },
    {
        name: "LEGO Star Wars Millennium Falcon",
        description: "Build and display the iconic Millennium Falcon from Star Wars with this detailed LEGO set, perfect for fans and collectors.",
        price: 159.99,
        category: "Toys",
        on_sale: false,
        new_arrival: true
    }       
]

products.each do |product_attrs|
            product = Product.find_or_create_by(name: product_attrs[:name])
            product.assign_attributes(product_attrs)
            product.save!

            # Attach a generic placeholder image if no image is attached
            if product.images.blank?
                require 'open-uri'
                file = URI.open("https://picsum.photos/seed/#{product.id}/600/400")
                product.images.attach(io: file, filename: "placeholder-#{product.id}.jpg")
                puts "Attached placeholder image for #{product.name}"
            end
end

puts "Sample products created!"