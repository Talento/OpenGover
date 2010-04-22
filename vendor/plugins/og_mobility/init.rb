require "og_mobility_controller"
Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgRackSeoOptimizer'
end