class GCMPusher < BasePusher
  ENDPOINT = 'https://android.googleapis.com/gcm/send'.freeze

  def self.key_prefix
    "google-cloud-messaging".freeze
  end

  def self.push(user, payload)
    updated = false

    message = {
      title: payload[:title],
      body: payload[:content],
      icon: ActionController::Base.helpers.asset_path('pokego.jpg'),
      tag: "chatty",
      url: payload[:url]
    }

    subscriptions(user).each do |_, subscription|
      subscription = JSON.parse(subscription)

      begin
        Webpush.payload_send(
          endpoint: subscription["endpoint"],
          message: message.to_json,
          p256dh: subscription.dig("keys", "p256dh"),
          auth: subscription.dig("keys", "auth"),
          api_key: 'AIzaSyCqpw_NRuLfhJKh83I-Z2GsVoqQ3tih4pI'
        )
      rescue Webpush::InvalidSubscription
        # Delete the subscription from Redis
        updated = true
        subscriptions(user).delete(extract_unique_id(subscription))
      end
    end

    user.save! if updated
  end
end
