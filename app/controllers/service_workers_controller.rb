class ServiceWorkersController < ActionController::Base
  layout false

  def push
    pathname =
      if Rails.env.production?
        "#{Rails.application.assets_manifest.directory}/#{Rails.application.assets_manifest.assets['push-service-worker.js']}"
      else
        Rails.application.assets.find_asset('push-service-worker.js').pathname
      end

    render file: pathname, content_type: Mime::JS
  end
end
