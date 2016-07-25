class PushNotificationsController < ApplicationController
  layout false

  def subscribe
    endpoint = push_params[:endpoint]

    if endpoint.start_with?(GCMPusher::ENDPOINT)
      GCMPusher.subscribe(current_user, push_params)
    elsif endpoint.start_with?(MozillaPusher::ENDPOINT)
      MozillaPusher.subscribe(current_user, push_params)
    end
  end

  def unsubscribe
    endpoint = push_params[:endpoint]

    if endpoint.start_with?(GCMPusher::ENDPOINT)
      GCMPusher.unsubscribe(current_user, push_params)
    elsif endpoint.start_with?(MozillaPusher::ENDPOINT)
      MozillaPusher.unsubscribe(current_user, push_params)
    end
  end

  private

  def push_params
    params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end
end
