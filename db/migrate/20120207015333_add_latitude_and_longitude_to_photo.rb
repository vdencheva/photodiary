class AddLatitudeAndLongitudeToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :latitude, :float
    add_column :photos, :longitude, :float
    add_column :photos, :gps_address, :string
  end
end
