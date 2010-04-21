require 'og_seo_optimizer'

OgSeoOptimizer.og_redirections = YAML.load(File.open("#{RAILS_ROOT}/static_files/og_redirections.yml")) rescue {}
