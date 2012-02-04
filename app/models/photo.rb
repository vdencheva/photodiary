class Photo < ActiveRecord::Base
  belongs_to :album
  
  mount_uploader :file, PhotoUploader
  
  validates_presence_of :file, :on => :create
  
  def previous_photo_id
    result = Photo.where("album_id = ? AND id < ?", album_id, id).order("id DESC").limit(1)
    result.first ? result.first.id : nil
  end
  
  def next_photo_id
    result = Photo.where("album_id = ? AND id > ?", album_id, id).order("id ASC").limit(1)
    result.first ? result.first.id : nil
  end
end
