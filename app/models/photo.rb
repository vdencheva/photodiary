class Photo < ActiveRecord::Base
  belongs_to :album
  
  mount_uploader :file, PhotoUploader
  
  validates_presence_of :file, :on => :create
  
end
