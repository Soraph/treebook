require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "that the /login route open the login page" do
   get '/login'
   assert_response :success
  end

  test "that the /logout route open the logout page" do
   get '/logout'
   assert_response :redirect
   assert_redirected_to '/'
  end

  test "that the /register route open the sign up page" do
   get '/register'
   assert_response :success
  end
end
