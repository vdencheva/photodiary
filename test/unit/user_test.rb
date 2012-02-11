require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  
  test "should not save user without username" do
    user = User.new(password: 'testpass',
                    email: 'tester3@example.com')
    assert !user.save
  end
  
  test "should not save user without password" do
    user = User.new(username: 'tester4',
                    email: 'tester4@example.com')
    assert !user.save
  end
  
  test "should not save user with short password" do
    user = User.new(username: 'tester5',
                    password: '123',
                    email: 'tester5@example.com')
    assert !user.save
  end
  
  test "should not save user without email" do
    user = User.new(username: 'tester6',
                    password: 'testpass')
    assert !user.save
  end
  
  test "should not save user with not valid email" do
    user = User.new(username: 'tester7',
                    password: 'testpass',
                    email: 'zzzz')
    assert !user.save
  end
  
  test "should not save user with not unique username or email" do
    user1 = User.new(username: 'tester1',
                    password: 'testpass',
                    email: 'tester8@example.com')
    assert !user1.save
    
    user2 = User.new(username: 'tester8',
                    password: 'testpass',
                    email: 'tester1@example.com')
    assert !user2.save
  end
  
  test "should save user with username password and email" do
    user = User.new(username: 'tester9',
                    password: 'testpass',
                    email: 'tester9@example.com')
    assert user.save
    assert user.valid?
  end
  
  test "should create hashed password before save" do
    user = User.new(username: 'tester10',
                    password: 'testpass',
                    email: 'tester10@example.com')
    user.save
    assert_equal User.encrypt('testpass'), user.hashed_password
  end
  
  test "hashed password can not be mass-assigned" do
    user = User.new(username: 'tester11',
                    hashed_password: 'testpass')
    assert_equal 'tester11', user.username
    assert_equal nil, user.hashed_password
  end
  
  test "hashed password can be directly assigned" do
    user = users(:one)
    user.update_attributes(:username => 'tester12',
                           :hashed_password => 'abv123')
    assert_equal 'tester12', user.username
    assert_not_equal 'abv123', user.hashed_password
    
    user.hashed_password = 'abv456'
    assert_equal 'abv456', user.hashed_password
  end
  
  test "should check if password is correct" do
    user = users(:one)
    assert user.has_password? 'testpass'
  end
  
  test "sould count albums for user" do
    user = users(:one)
    assert_equal user.albums.size, user.albums_count
  end
  
  test "should count photos for user" do
    user = users(:one)
    assert_equal user.photos.size, user.photos_count
  end
  
end
