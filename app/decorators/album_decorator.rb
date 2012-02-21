class AlbumDecorator < ApplicationDecorator
  decorates :album

  def first_image_src
    album.first_photo.try{ |p| p.file.thumb.url } || h.asset_path('nophotos.png')
  end
end