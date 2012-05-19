class PhotoDecorator < ApplicationDecorator
  decorates :photo

  def previous_photo_tag
    photo.previous_photo.try { |p| h.link_to I18n.t('photos.show.previous'), h.album_photo_path(album, p), class: "leftPhotoLink" }
  end

  def next_photo_tag
    photo.next_photo.try { |p| h.link_to I18n.t('photos.show.next'), h.album_photo_path(album, p), class: "rightPhotoLink" }
  end
end