class Photo < ActiveRecord::Base  
  include ExifData
  
  belongs_to :album
  
  mount_uploader :file, PhotoUploader
  
  before_create :set_photo_attributes
  
  validates_presence_of :file, :on => :create
  
  def previous_photo_id
    result = Photo.where("album_id = ? AND id < ?", album_id, id).order("id DESC").limit(1)
    result.first ? result.first.id : nil
  end
  
  def next_photo_id
    result = Photo.where("album_id = ? AND id > ?", album_id, id).order("id ASC").limit(1)
    result.first ? result.first.id : nil
  end
  
  def increment_views
    increment!(:views)
  end
  
  private
  
  def set_photo_attributes
    extract_exif_data(file.path)
    write_attribute(:camera_model, get_model)
    write_attribute(:date_taken, get_date_time)
    write_attribute(:exposure_time, get_exposure_time)
    write_attribute(:f_number, get_f_number)
    write_attribute(:iso_speed, get_iso_speed)
    write_attribute(:flength_35mm_film, get_focal_length_in_35mm_film)
    write_attribute(:flash, get_flash)
  end
end
