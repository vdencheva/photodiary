class AddUserIndexToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.index :user_id
    end
  end
end
