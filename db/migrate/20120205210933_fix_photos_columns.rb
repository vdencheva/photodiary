class FixPhotosColumns < ActiveRecord::Migration
  def up
    change_column :photos, :album_id, :integer, :null => false;
    change_column :photos, :file, :string, :null => false;
  end

  def down
    change_column :photos, :file, :string, :null => true;
    change_column :photos, :album_id, :integer, :null => true;
  end
end
