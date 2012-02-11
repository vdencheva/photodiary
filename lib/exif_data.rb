require 'exifr'

module ExifData
  FLASH_CODES = { '0' => 'Flash did not fire',
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
  
  def extract_exif_data(file_path)
    case file_path.downcase
    when /\.jpg\Z/
      @exif_data = EXIFR::JPEG.new(file_path)
    when /\.tiff?\Z/
      @exif_data = EXIFR::TIFF.new(file_path)
    else
      @exif_data = nil
    end
  end
  
  def get_model
    @exif_data.model.nil? ? '' : @exif_data.model.to_s
  end
  
  def get_date_time
    @exif_data.date_time_original.nil? ? '' : @exif_data.date_time_original.to_s
  end
  
  def get_exposure_time
    exposure_time_int = @exif_data.exposure_time.to_i
    exposure_time_val = (@exif_data.exposure_time == exposure_time_int ? exposure_time_int : @exif_data.exposure_time)
    @exif_data.exposure_time.nil? ? '' : (exposure_time_val.to_s + ' sec')
  end
  
  def get_f_number
    if @exif_data.f_number
      f_number_float = @exif_data.f_number.to_f
      f_number_int = f_number_float.to_i
      f_number_val = (f_number_float == f_number_int ? f_number_int : f_number_float)
      'f/' + f_number_val.to_s
    else
      ''
    end
  end
  
  def get_iso_speed
    @exif_data.iso_speed_ratings ? ('ISO-' + @exif_data.iso_speed_ratings.to_s) : ''
  end
  
  def get_focal_length_in_35mm_film
    @exif_data.focal_length_in_35mm_film ? (@exif_data.focal_length_in_35mm_film.to_s + ' mm') : ''
  end
  
  def get_flash
    if @exif_data.flash
      hex_code = @exif_data.flash.to_s(16).upcase
      FLASH_CODES[hex_code] ? FLASH_CODES[hex_code] : ''
    else
      ''
    end
  end
  
  def get_latitude
    gps_lat = get_coordinate(@exif_data.gps_latitude)
    if gps_lat
      gps_lat = gps_lat * (-1) if @exif_data.gps_latitude_ref && @exif_data.gps_latitude_ref.upcase == "S"
    end
    gps_lat
  end
  
  def get_longitude
    gps_long = get_coordinate(@exif_data.gps_longitude)
    if gps_long
      gps_long = gps_long * (-1) if @exif_data.gps_longitude_ref && @exif_data.gps_longitude_ref.upcase == "W"
    end
    gps_long
  end
  
  def get_coordinate(coord_array)
    if coord_array && coord_array.kind_of?(Array)
      value = coord_array[0];
      value += (coord_array[1] ? coord_array[1]/60 : 0)
      value += (coord_array[2] ? coord_array[2]/3600 : 0)
      value.to_f.round(3)
    else
      ''
    end
  end
  
  def get_gps_address(lat, long)
    obj = Geocoder.search([lat, long])
    obj.first ? obj.first.formatted_address : ''
  end
  
  def get_orientation
    orientation = @exif_data.orientation.to_i
  end
end
