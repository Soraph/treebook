class UserNotifier < ActionMailer::Base
  default from: "from@example.com"

  def friend_requested(user_friendship_id)
    friend_notification(user_friendship_id,"wants to be your friend on Treebook")
  end

  def friend_request_accepted(user_friendship_id) 
    friend_notification(user_friendship_id,"has accepted your friend request")
  end

  def friend_notification(user_friendship_id, email_subject)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@friend.first_name} #{email_subject}."
  end
end
