require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  fixtures :users, :albums
  
  def setup
    @user = users(:one)
  end
  
  test "should not save album without title" do
    album = @user.albums.build(description: 'tralala')
    assert !album.save
  end
  
  test "should not save album with not unique title in scope of user" do
    album1 = @user.albums.build(title: 'this album')
    album1.save
    album2 = @user.albums.build(title: 'this album')
    assert !album2.save
  end
  
  test "should save album with not unique title" do
    album1 = @user.albums.build(title: 'that album')
    album1.save
    album2 = users(:two).albums.build(title: 'that album')
    assert album2.save
  end
  
  test "should save album with title" do
    album = @user.albums.build(title: 'this album1',
                               description: 'test description')
    assert album.save
    assert album.valid?
  end
  
  test "album owner can not be mass-assigned" do
    user_two_id = users(:two).id
    album = @user.albums.new(title: 'this album2',
                             user_id: user_two_id)
    assert_equal 'this album2', album.title
    assert_equal @user.id, album.user_id
  end
  
  test "album owner can be directly assigned" do
    user_two_id = users(:two).id
    album = albums(:one)
    album.update_attributes(title: 'this album3',
                            user_id: user_two_id)
    assert_equal 'this album3', album.title
    assert_not_equal user_two_id, album.user_id
    
    album.user_id = user_two_id
    assert_equal user_two_id, album.user_id
  end
  
  test "should count photos in album" do
    album = albums(:one)
    assert_equal album.photos.size, album.photos_count
  end
end
