class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos, :dependent => :destroy
  has_many :comments, :through => :photos
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :user_id, :if => -> { title.present? }
  
  attr_protected :user_id
  
  def first_photo
    result = Photo.where(:album_id => id).order("id ASC").limit(1)
    result.first ? result.first.file.thumb.url : "/assets/nophotos.png"
  end
  
  def photos_count
    photos.count
  end
end
