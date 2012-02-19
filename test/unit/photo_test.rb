require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  fixtures :users, :albums, :photos
  
  def setup
    @album = albums(:one)
  end
  
  test "should not create photo without file" do
    photo = @album.photos.build()
    assert !photo.save
  end
  
  test "should create photo with file" do
    photo = @album.photos.build(file: File.open(Rails.root.join('test/fixtures/DSC_5729.jpg')))
    assert photo.save
    assert photo.valid?
  end
  
  test "photo album can not be mass-assigned" do
    album_two_id = albums(:two).id
    photo = @album.photos.build(file: File.open(Rails.root.join('test/fixtures/DSC_5729.jpg')),
                                album_id: album_two_id)
    assert_equal @album.id, photo.album_id
  end
  
  test "photo album can be directly assigned" do
    album_two_id = albums(:two).id
    photo = photos(:one)
    photo.update_attributes(album_id: album_two_id)
    assert_not_equal album_two_id, photo.album_id
    
    photo.album_id = album_two_id
    assert_equal album_two_id, photo.album_id
  end
  
  test "should get photo exif details before save" do
    photo = @album.photos.build(file: File.open(Rails.root.join('test/fixtures/DSC_6865.jpg')))
    assert photo.save
    assert_equal 'NIKON D5000', photo.camera_model
    assert_equal '1/400 sec', photo.exposure_time
    assert_equal 'f/10', photo.f_number
    assert_equal 'ISO-200', photo.iso_speed
    assert_equal '82 mm', photo.flength_35mm_film
    assert_equal I18n.t("exif_data.code_0"), photo.flash
  end
  
  test "should increment photo views" do
    photo = photos(:one)
    views = photo.views
    photo.increment_views
    assert_equal (views + 1), photo.views
  end
  
  test "get previous and next photo in the album" do
    album = albums(:one)
    photo = photos(:two)
    assert_equal album.photos.find('id < ?', photo.id).order('id DESC').first, photo.previous_photo
    assert_equal album.photos.find('id > ?', photo.id).order('id ASC').first, photo.next_photo
  end
end
