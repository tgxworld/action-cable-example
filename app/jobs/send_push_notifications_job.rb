class SendPushNotificationsJob < ApplicationJob
  queue_as :default

  def perform(params)
    User.all.where.not(id: params[:user_id]).each do |user|
      [GCMPusher, MozillaPusher].each do |pusher|
        pusher.public_send(:push, user, params[:payload])
      end
    end
  end
end
