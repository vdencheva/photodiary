require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  fixtures :users, :photos, :comments
  
  def setup
    @photo = photos(:one)
    @user = users(:one)
  end
  
  test "should not create comment without body" do
    comment = @photo.comments.build()
    assert !comment.save
  end
  
  test "should create comment with body" do
    comment = @photo.comments.build(body: 'test comment body here')
    comment.user = @user
    assert comment.save
    assert comment.valid?
  end
  
  test "comment owner and photo can not be mass-assigned" do
    user_two_id = users(:two).id
    photo_two_id = photos(:two).id
    comment = @photo.comments.build(body: 'test comment',
                                    user_id: user_two_id,
                                    photo_id: photo_two_id)
    assert_equal 'test comment', comment.body
    assert_not_equal user_two_id, comment.user_id
    assert_not_equal photo_two_id, comment.photo_id
  end
  
  test "comment owner and photo can be directly assigned" do
    user_two_id = users(:two).id
    photo_two_id = photos(:two).id
    comment = comments(:one)
    comment.update_attributes(user_id: user_two_id,
                              photo_id: photo_two_id)
    assert_not_equal user_two_id, comment.user_id
    assert_not_equal photo_two_id, comment.photo_id
    
    comment.user_id = user_two_id
    assert_equal user_two_id, comment.user_id
    
    comment.photo_id = photo_two_id
    assert_equal photo_two_id, comment.photo_id
  end
  
end
