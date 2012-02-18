class AddSaltToUsers < ActiveRecord::Migration
  def up
    add_column :users, :salt, :string, :default => '';
    User.update_all(['salt = ?', '']);
  end
  
  def down
    remove_column :users, :salt;
  end
end
