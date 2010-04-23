require 'og_seo_optimizer'
Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgRackSeoOptimizer'
end
