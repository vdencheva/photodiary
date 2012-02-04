class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  
  validates_presence_of :title
  validates_uniqueness_of :title, :if => -> { title.present? }
end
