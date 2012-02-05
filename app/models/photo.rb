require 'exifr'

class Photo < ActiveRecord::Base  
  belongs_to :album
  
  mount_uploader :file, PhotoUploader
  
  before_create :extract_exif_data
  
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
  
  def extract_exif_data
    case file.path.downcase
    when /\.jpg\Z/
      exif_data = EXIFR::JPEG.new(file.path)
    when /\.tiff?\Z/
      exif_data = EXIFR::TIFF.new(file.path)
    else
      exif_data = nil
    end
    set_photo_attributes(exif_data) unless exif_data.nil?
  end
  
  def set_photo_attributes(exif_data)
    unless exif_data.model.nil?
      write_attribute(:camera_model, exif_data.model.to_s)
    end
    unless exif_data.date_time_original.nil?
      write_attribute(:date_taken, exif_data.date_time_original.to_s)
    end
    unless exif_data.exposure_time.nil?
      write_attribute(:exposure_time, exif_data.exposure_time.to_s + ' sec')
    end
    unless exif_data.f_number.nil?
      f_number_float = exif_data.f_number.to_f
      f_number_int = f_number_float.to_i
      f_number_val = (f_number_float == f_number_int ? f_number_int : f_number_float)
      write_attribute(:f_number, 'f/' + f_number_val.to_s)
    end
    unless exif_data.iso_speed_ratings.nil?
      write_attribute(:iso_speed, 'ISO-' + exif_data.iso_speed_ratings.to_s)
    end
    unless exif_data.flash.nil?
      flash_msg = flash_value(exif_data.flash.to_s(16))
      write_attribute(:flash, flash_msg)
    end
    unless exif_data.focal_length_in_35mm_film.nil?
      write_attribute(:flength_35mm_film, exif_data.focal_length_in_35mm_film.to_s + ' mm')
    end
  end
  
  def flash_value(code_hex)
    flash_hash = {'0' => 'Flash did not fire',
                  '1' => 'Flash fired',
                  '5' => 'Strobe return light not detected',
                  '7' => 'Strobe return light detected',
                  '9' => 'Flash fired, compulsory flash mode',
                  'D' => 'Flash fired, compulsory flash mode, return light not detected',
                  'F' => 'Flash fired, compulsory flash mode, return light detected',
                  '10' => 'Flash did not fire, compulsory flash mode',
                  '18' => 'Flash did not fire, auto mode',
                  '19' => 'Flash fired, auto mode',
                  '1D' => 'Flash fired, auto mode, return light not detected',
                  '1F' => 'Flash fired, auto mode, return light detected',
                  '20' => 'No flash function',
                  '41' => 'Flash fired, red-eye reduction mode',
                  '45' => 'Flash fired, red-eye reduction mode, return light not detected',
                  '47' => 'Flash fired, red-eye reduction mode, return light detected',
                  '49' => 'Flash fired, compulsory flash mode, red-eye reduction mode',
                  '4D' => 'Flash fired, compulsory flash mode, red-eye reduction mode, return light not detected',
                  '4F' => 'Flash fired, compulsory flash mode, red-eye reduction mode, return light detected',
                  '59' => 'Flash fired, auto mode, red-eye reduction mode',
                  '5D' => 'Flash fired, auto mode, return light not detected, red-eye reduction mode',
                  '5F' => 'Flash fired, auto mode, return light detected, red-eye reduction mode',
                 }
    flash_hash[code_hex.upcase] ? flash_hash[code_hex.upcase] : ''
  end
end
