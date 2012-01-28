class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :full_name
      t.string :email
      t.text :description

      t.timestamps
    end
  end
end
