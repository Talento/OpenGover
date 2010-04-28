require 'og_seo_optimizer'
require 'og_base_seo_optimizer_controller'
Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgRackSeoOptimizer'
end
