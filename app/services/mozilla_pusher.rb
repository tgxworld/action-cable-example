class MozillaPusher < BasePusher
  ENDPOINT = 'https://updates.push.services.mozilla.com/push'.freeze

  def self.key_prefix
    "push-services-mozilla".freeze
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
        payload = Webpush::Encryption.encrypt(
          message.to_json,
          subscription.dig("keys", "p256dh"),
          subscription.dig("keys", "auth")
        )

        Webpush::Request.new(subscription["endpoint"], { payload: payload }).perform
      rescue Webpush::InvalidSubscription => e
        updated = true
        subscriptions(user).delete(extract_unique_id(subscription))
      end
    end

    user.save! if updated
  end
end
