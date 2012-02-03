class Album < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title
  validates_uniqueness_of :title, :if => -> { title.present? }
  
end
