require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)

  test "a user should enter a first name" do
    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
    user = User.new
    assert !user.save
    assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
    user = User.new
    user.profile_name = users(:profiler).profile_name

    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'Pro', last_name: 'Filer', email: 'profiler2@revenge.com')
    user.password = user.password_confirmation = 'test123456'
    user.profile_name = "Name with spaces"

    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'Pro', last_name: 'Filer', email: 'profiler2@revenge.com')
    user.password = user.password_confirmation = 'test123456'
    user.profile_name = 'Profiler2'

    assert user.valid?
  end

  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:profiler).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:profiler).friends << users(:newuser)
    users(:profiler).friends.reload
    assert users(:profiler).pending_friends.include?(users(:newuser))
  end

  test "that calling to_param in a user returns the profile_name" do
    assert_equal "Profiler", users(:profiler).to_param
  end

end
