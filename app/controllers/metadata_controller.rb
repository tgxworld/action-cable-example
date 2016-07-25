class MetadataController < ActionController::Base
  layout false

  def manifest
    manifest = {
      name: 'Chatty',
      short_name: "Chatty",
      display: 'standalone',
      orientation: 'portrait',
      icons: [
        {
          src: ActionController::Base.helpers.asset_path('pokego.jpg'),
          sizes: "144x144",
          type: "image/png"
        }
      ],
      gcm_sender_id: '439495341364'
    }

    render json: manifest.to_json
  end
end
