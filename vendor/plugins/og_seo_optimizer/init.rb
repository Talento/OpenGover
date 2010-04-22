require 'og_seo_optimizer'
Rails.configuration.after_initialize do
      Rails.configuration.middleware.use 'OgRackSeoOptimizer'
end
OgSeoOptimizer.og_redirections = YAML.load(File.open("#{RAILS_ROOT}/static_files/og_redirections.yml")) rescue {}
