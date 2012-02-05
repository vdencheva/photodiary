require 'digest/sha1'

class User < ActiveRecord::Base  
  has_many :albums
  
  attr_accessor :password, :remove_photo
  
  mount_uploader :photo, AvatarUploader
  
  before_save :create_hashed_password, :update_photo
  
  validates_presence_of :username
  validates_uniqueness_of :username, :if => -> { username.present? }
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 6, :if => -> { password.present? }
  validates_confirmation_of :password, :if => -> { password.present? }
  validates_presence_of :email
  validates_uniqueness_of :email, :if => -> { email.present? }
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :if => -> { email.present? }
  
  def self.authenticate(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    return user if user.has_password?(password)
    nil
  end
  
  def has_password?(password)
    self.hashed_password == User.encrypt(password)
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password)
  end
  
  def avatar
    photo.url ? photo.thumb.url : "/assets/noavatar.png"
  end
  
  def albums_count
    Album.where(:user_id => id).size
  end
  
  def photos_count
    Photo.where("album_id IN(SELECT id FROM albums WHERE user_id = ?)", id).size
  end
  
  private
  
  def create_hashed_password
    write_attribute(:hashed_password, User.encrypt(password)) if password.present?
  end
  
  def update_photo
    write_attribute(:photo, '') if remove_photo.present? && remove_photo == '1'
  end 
end
