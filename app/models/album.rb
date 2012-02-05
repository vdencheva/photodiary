class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :user_id, :if => -> { title.present? }
  
  def first_photo
    result = Photo.where(:album_id => id).order("id ASC").limit(1)
    result.first ? result.first.file.thumb.url : "/assets/nophotos.png"
  end
end
