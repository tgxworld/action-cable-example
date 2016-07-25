class MessagesController < ApplicationController

  def create
    message = Message.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast 'messages',
        message: message.content,
        user: message.user.username

      SendPushNotificationsJob.perform_later({
        user_id: current_user.id,
        payload: {
          title: "#{message.user.username} Posted",
          content: message.content,
          url: "/chatrooms/#{Chatroom.find(message.chatroom_id).slug}"
        }
      })

      head :ok
    end
  end

  private

    def message_params
      params.require(:message).permit(:content, :chatroom_id)
    end
end
