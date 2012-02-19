require 'exifr'

module ExifData
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
      flash_text = I18n.t("exif_data.#{hex_code}")
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
