require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#new" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:profiler)
      end

      should "get new and return success" do
        get :new
        assert_response :success
      end

      should "set a flash error if the friend_id param is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end

      should "display the friend's name" do
        get :new, friend_id: users(:newuser)
        assert_match /#{users(:newuser).full_name}/, response.body
      end

      should "assign a new user friendship" do
        get :new, friend_id: users(:newuser)
        assert assigns(:user_friendship)
      end

      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:newuser)
        assert_equal users(:newuser), assigns(:user_friendship).friend
      end

      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:newuser)
        assert_equal users(:profiler), assigns(:user_friendship).user
      end

      should "return a 404 status if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:newuser)
        assert_match /Do you really want to friend #{users(:newuser).full_name}?/, response.body
      end
    end
  end
end