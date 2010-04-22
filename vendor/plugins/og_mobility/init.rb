require "og_mobility"
Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgMobility'
end