class UserNotifier < ActionMailer::Base
  default from: "from@example.com"

  def friend_requested(user_friendship_id) 
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@friend.first_name} wants to be your friend on Treebook"
  end

  def friend_request_accepted(user_friendship_id) 
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@friend.first_name} has accepted your friend request."
  end
end
