# app/admin/users.rb

ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :phone, :address_line_1, 
                :address_line_2, :city, :postal_code, :province_id
  
  # Index page configuration
  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :phone
    column :province do |user|
      user.province.name if user.province
    end
    column "Orders" do |user|
      link_to user.orders.count, admin_orders_path(q: { user_id_eq: user.id })
    end
    column :created_at
    actions
  end
  
  # Filters
  filter :first_name
  filter :last_name
  filter :email
  filter :province
  filter :created_at
  
  # Show page configuration
  show do
    attributes_table do
      row :full_name
      row :email
      row :phone
      row :full_address do |user|
        user.address_complete? ? simple_format(user.full_address) : "No address provided"
      end
      row :created_at
      row :updated_at
    end
    
    panel "Orders (#{user.orders.count})" do
      if user.orders.any?
        table_for user.orders.recent.limit(10) do
          column "Order Number" do |order|
            link_to order.order_number, admin_order_path(order)
          end
          column :order_date
          column :status do |order|
            status_tag order.status
          end
          column :total do |order|
            number_to_currency(order.total)
          end
        end
        div do
          link_to "View All Orders", admin_orders_path(q: { user_id_eq: user.id })
        end
      else
        div "No orders placed yet."
      end
    end
  end
  
  # Form configuration
  form do |f|
    f.inputs "Personal Information" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
    end
    
    f.inputs "Address" do
      f.input :address_line_1
      f.input :address_line_2
      f.input :city
      f.input :province, as: :select, collection: Province.all.order(:name)
      f.input :postal_code
    end
    
    f.actions
  end
end