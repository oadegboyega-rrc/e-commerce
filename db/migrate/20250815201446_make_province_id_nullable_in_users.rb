class MakeProvinceIdNullableInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :province_id, true
  end
end
