class FixUsersColumns < ActiveRecord::Migration
  def up
    change_column :users, :username, :string, :null => false;
    change_column :users, :email, :string, :null => false;
    add_index :users, [ :username ], :unique => true;
    add_index :users, [ :email ], :unique => true;
  end

  def down
    remove_index :users, :name => :index_users_on_email
    remove_index :users, :name => :index_users_on_username
    change_column :users, :email, :string, :null => true;
    change_column :users, :username, :string, :null => true;
  end
end
