require 'digest/sha1'

class User < ActiveRecord::Base  
  has_many :albums, dependent: :destroy
  has_many :photos, through: :albums
  has_many :comments, dependent: :destroy

  attr_accessor :password, :remove_photo

  attr_protected :hashed_password, :salt

  mount_uploader :photo, AvatarUploader

  before_save :create_hashed_password, :update_photo

  validates_presence_of :username
  validates_uniqueness_of :username, if: -> { username.present? }
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 6, if: -> { password.present? }
  validates_confirmation_of :password, if: -> { password.present? }
  validates_presence_of :email
  validates_uniqueness_of :email, if: -> { email.present? }
  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, if: -> { email.present? }

  def self.authenticate(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    return user if user.has_password?(password)
    nil
  end

  def has_password?(password)
    self.hashed_password == User.encrypt(password, salt)
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password+salt)
  end

  def generate_salt
    self.object_id.to_s + rand.to_s
  end

  def avatar_standard
    photo.thumb.try(:url)
  end

  def has_photo?
    photo.url ? true : false
  end

  def avatar_small
    photo.small_thumb.try(:url)
  end

  def albums_count
    albums.size
  end

  def photos_count
    photos.size
  end

  private

  def create_hashed_password
    if password.present?
      new_salt = generate_salt
      write_attribute(:salt, new_salt)
      write_attribute(:hashed_password, User.encrypt(password, new_salt))
    end
  end

  def update_photo
    write_attribute(:photo, '') if remove_photo.present? && remove_photo == '1'
  end 
end
