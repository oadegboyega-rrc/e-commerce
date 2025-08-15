# app/admin/orders.rb

ActiveAdmin.register Order do
  # Feature 3.2.2 - Order status management
  permit_params :status
  
  # Scopes for filtering orders
  scope :all, default: true
  scope :pending
  scope :paid
  scope :shipped
  scope :delivered
  scope :cancelled
  
  # Index page configuration
  index do
    selectable_column
    id_column
    column "Order Number", :order_number
    column :user do |order|
      link_to order.user.full_name, admin_user_path(order.user) if order.user
    end
    column :order_date
    column :status do |order|
      status_tag order.status, class: case order.status
                                     when 'pending' then 'warning'
                                     when 'paid' then 'ok'
                                     when 'shipped' then 'blue'
                                     when 'delivered' then 'green'
                                     when 'cancelled' then 'red'
                                     else 'gray'
                                     end
    end
    column :total_items
    column :subtotal do |order|
      number_to_currency(order.subtotal)
    end
    column :tax_amount do |order|
      number_to_currency(order.tax_amount)
    end
    column :total do |order|
      number_to_currency(order.total)
    end
    actions
  end
  
  # Filters
  filter :user, as: :select, collection: -> { User.joins(:orders).distinct.pluck(:first_name, :last_name, :id).map { |f, l, id| ["#{f} #{l}", id] } }
  filter :status, as: :select, collection: %w[pending paid shipped delivered cancelled]
  filter :order_date
  filter :total
  
  # Show page configuration  
  show do
    attributes_table do
      row :order_number
      row :user do |order|
        link_to order.user.full_name, admin_user_path(order.user) if order.user
      end
      row :order_date
      row :status do |order|
        status_tag order.status, class: case order.status
                                       when 'pending' then 'warning'
                                       when 'paid' then 'ok'
                                       when 'shipped' then 'blue'
                                       when 'delivered' then 'green'
                                       when 'cancelled' then 'red'
                                       else 'gray'
                                       end
      end
      row :billing_address do |order|
        simple_format(order.billing_address)
      end
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :tax_amount do |order|
        number_to_currency(order.tax_amount)
      end
      row :total do |order|
        number_to_currency(order.total)
      end
      row :province do |order|
        order.province.name if order.province
      end
    end
    
    panel "Order Items" do
      table_for order.order_items do
        column "Product" do |item|
          link_to item.product.name, admin_product_path(item.product)
        end
        column :quantity
        column "Unit Price" do |item|
          number_to_currency(item.price)
        end
        column "Total" do |item|
          number_to_currency(item.total_price)
        end
      end
    end
    
    panel "Quick Status Update" do
      form_for [:admin, order], url: admin_order_path(order), method: :patch do |f|
        f.select :status, 
          options_for_select([
            ['Pending', 'pending'],
            ['Paid', 'paid'],
            ['Shipped', 'shipped'],
            ['Delivered', 'delivered'],
            ['Cancelled', 'cancelled']
          ], order.status),
          {},
          { onchange: "this.form.submit();" }
      end
    end
  end
  
  # Form for editing orders (limited to status)
  form do |f|
    f.inputs "Order Status" do
      f.input :status, as: :select, collection: [
        ['Pending', 'pending'],
        ['Paid', 'paid'],
        ['Shipped', 'shipped'],
        ['Delivered', 'delivered'],
        ['Cancelled', 'cancelled']
      ], include_blank: false
    end
    f.actions
  end
  
  # Custom actions
  action_item :mark_paid, only: :show, if: proc { order.status == 'pending' } do
    link_to "Mark as Paid", mark_paid_admin_order_path(order), method: :patch
  end
  
  action_item :mark_shipped, only: :show, if: proc { order.status == 'paid' } do
    link_to "Mark as Shipped", mark_shipped_admin_order_path(order), method: :patch
  end
  
  member_action :mark_paid, method: :patch do
    resource.update(status: 'paid')
    redirect_to admin_order_path(resource), notice: "Order marked as paid"
  end
  
  member_action :mark_shipped, method: :patch do
    resource.update(status: 'shipped')
    redirect_to admin_order_path(resource), notice: "Order marked as shipped"
  end
end