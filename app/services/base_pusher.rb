class BasePusher
  def self.key_prefix
    raise "Not implemented."
  end

  def self.push(user, payload)
    raise "Not implemented."
  end

  def self.subscriptions(user)
    user.push_subscriptions ||= {}
    user.push_subscriptions[key_prefix] ||= {}
    user.push_subscriptions[key_prefix]
  end

  def self.clear_subscriptions(user)
    user.push_subscriptions ||= {}
    user.push_subscriptions[key_prefix] = {}
  end

  def self.subscribe(user, subscription)
    subscriptions(user)[extract_unique_id(subscription)] = subscription.to_json
    user.save!
  end

  def self.unsubscribe(user, subscription)
    subscriptions(user).delete(extract_unique_id(subscription))
    user.save!
  end

  protected

  def self.extract_unique_id(subscription)
    subscription["endpoint"].split("/").last
  end
end
