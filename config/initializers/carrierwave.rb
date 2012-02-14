module CarrierWave
  module MiniMagick
    # Rotates the image based on the EXIF Orientation
    def fix_image_orientation
      manipulate! do |img|
        # img.auto_orient
        correct_orientation(img, img["EXIF:orientation"].to_i)
        img = yield(img) if block_given?
        img
      end
    end
    
    def correct_orientation(img, orientation)
      case orientation
      when 2
        # 0th Row: top, 0th Column: right side
        img.flop
      when 3
        # 0th Row: bottom, 0th Column: right side
        img.rotate '180'
      when 4
        # 0th Row: bottom, 0th Column: left side
        img.flip
      when 5
        # 0th Row: left side, 0th Column: top
        img.transpose
      when 6
        # 0th Row: right side, 0th Column: top
        img.rotate '90'
      when 7
        # 0th Row: right side, 0th Column: bottom
        img.transverse
      when 8
        # 0th Row: left side, 0th Column: bottom
        img.rotate '270'
      end
    end
  end
end