class AddForeignKeyToAlbums < ActiveRecord::Migration
  def up
    change_column :albums, :user_id, :integer, :null => false;
    change_column :albums, :title, :string, :null => false;
    add_index :albums, [ :user_id, :title ], :unique => true;
  end
  
  def down
    remove_index :albums, :name => :index_albums_on_user_id_and_title;
    change_column :albums, :title, :string, :null => true;
    change_column :albums, :user_id, :integer, :null => true;
  end
end
