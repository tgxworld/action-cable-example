class ServiceWorkersController < ActionController::Base
  layout false

  def push
    pathname =
      if Rails.env.production?
        assets_manifest.assets['push-service-worker.js'].pathname
      else
        Rails.application.assets.find_asset('push-service-worker.js').pathname
      end

    render file: pathname, content_type: Mime::JS
  end
end
