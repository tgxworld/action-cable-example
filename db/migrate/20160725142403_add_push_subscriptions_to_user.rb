class AddPushSubscriptionsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :push_subscriptions, :json
  end
end
