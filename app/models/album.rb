class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy, order: 'photos.id DESC'
  has_many :comments, through: :photos

  validates_presence_of :title
  validates_uniqueness_of :title, scope: :user_id, if: -> { title.present? }

  attr_protected :user_id

  def first_photo
    Photo.where(album_id: id).order("id ASC").first
  end

  def photos_count
    photos.size
  end
end
