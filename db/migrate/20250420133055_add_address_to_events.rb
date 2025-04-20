class AddAddressToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :address, :text
  end
end
