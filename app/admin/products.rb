ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category, :on_sale, :new_arrival, images: []
  
  #Index page configuration
  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price do |product|
      number_to_currency(product.price)
    end
    column :on_sale
    column :new_arrival
    column "Images" do |product|
      product.images.count
    end
    column :created_at
    actions
  end

  #Filters for the index page
  filter :name
  filter :category
  filter :price
  filter :on_sale
  filter :new_arrival
  filter :created_at

  #Show page configuration
  show do
    attributes_table do
      row :name
      row :description
      row :category
      row :price do |product|
        number_to_currency(product.price)
      end
      row :on_sale
      row :new_arrival
      row :created_at
      row :updated_at
      row :images do |product|
        if product.images.attached?
          product.images.map do |image|
            image_tag image, style: "max-width: 200px; margin:10px;"
          end.join.html_safe
        else
          "No images uploaded"
        end
      end
    end
  end

  #Form configuration
  form do |f|
    f.inputs "Product Details" do
      f.input :name
  f.input :description, as: :text, rows: 5
  f.input :price, as: :number, step: 0.01, min: 0.01
      f.input :category, as: :select, collection: [
        'Electronics', 'Books', 'Clothing', 'Home', 'Toys', 'Sports', 'Beauty'
      ], prompt: 'Select a category'
      f.input :on_sale
      f.input :new_arrival
    end

    f.inputs "Images" do
     f.input :images, as: :file, input_html: { multiple: true }
    end 

    f.actions
  end

  # Uncomment and customize the permitted parameters section below to permit additional parameters.

      


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :category, :on_sale, :new_arrival
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :category, :on_sale, :new_arrival]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
