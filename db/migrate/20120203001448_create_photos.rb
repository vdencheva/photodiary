class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :album
      t.string :file
      t.string :title
      t.datetime :date_taken
      t.string :place_taken
      t.string :camera
      t.string :model
      t.text :other
      t.integer :views

      t.timestamps
    end
    add_index :photos, :album_id
  end
end
