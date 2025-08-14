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
    Product.find_or_create_by(name: product_attrs[:name]) do |product|
        product.assign_attributes(product_attrs)
    end
end

puts "Sample products created!"