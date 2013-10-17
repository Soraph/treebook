require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  
  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:profiler), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:profiler), friend: create(:user, first_name: 'Active', last_name: 'Friend'))

        sign_in users(:profiler)
        get :index
      end

      should "get the index page withpout error" do
        assert_response :success
      end

      should "assign user_friendship" do
        assert assigns(:user_friendships)
      end

      should "display frriend's name" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship is pending."
        end
      end

      should "display date information on an accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friendship started #{@friendship2.updated_at}."
        end
      end

    end
  end

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

  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:profiler)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to the site root" do
          assert_redirected_to root_path
        end
      end

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: { friend_id: users(:newuser).profile_name }
          end
        end
      end

      context "with a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:newuser) }
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:newuser), assigns(:friend)
        end

        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:profiler), assigns(:user_friendship).user
          assert_equal users(:newuser), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:profiler).pending_friends.include?(users(:newuser))
        end

        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_page_path(users(:newuser))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent.", flash[:success]
        end
      end
    end
  end

  context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:profiler))
        sign_in users(:profiler)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the friendship to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end

      should "have a flash success message" do
        assert_equal "You are now friend with #{@user_friendship.friend.full_name}", flash[:success]
      end
    end

    context "#edit" do
      context "when not logged in" do
        should "redirect to the login page" do
          get :edit, id: 1
          assert_response :redirect
        end
      end

      context "when logged in" do
        setup do
          @user_friendship = create(:pending_user_friendship, user: users(:profiler))
          sign_in users(:profiler)
          get :edit, id: @user_friendship
        end

        should "get edit and return success" do
          assert_response :success
        end

        should "assign to user_friendship" do
          assert assigns(:user_friendship)
        end

        should "assign to friend" do
          assert assigns(:friend)
        end

      end

    end

  end
end