class FixPhotoColumns < ActiveRecord::Migration
  def up
    rename_column :photos, :camera, :camera_model;
    rename_column :photos, :model, :exposure_time;
    rename_column :photos, :other, :f_number;
    add_column :photos, :iso_speed, :string;
    add_column :photos, :flash, :string;
    add_column :photos, :flength_35mm_film, :string;
  end

  def down
    remove_column :photos, :flength_35mm_film;
    remove_column :photos, :flash;
    remove_column :photos, :iso_speed;
    rename_column :photos, :f_number, :other;
    rename_column :photos, :exposure_time, :model;
    rename_column :photos, :camera_model, :camera;
  end
end
