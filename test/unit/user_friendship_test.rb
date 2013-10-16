require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising an exception" do
    assert_nothing_raised do
     UserFriendship.create user: users(:profiler), friend: users(:moreuser)
    end
  end

  test "that creating a friendship based on a user id and friend id works" do
    UserFriendship.create user_id: users(:profiler).id, friend_id: users(:newuser).id
    assert users(:profiler).friends.include?(users(:newuser))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:profiler), friend: users(:newuser)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:profiler), friend: users(:newuser)
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size' do
        @user_friendship.send_request_email
      end
    end
  end
end
