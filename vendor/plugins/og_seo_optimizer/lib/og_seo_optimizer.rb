module OgSeoOptimizer

  def self.og_redirections
    redirections = {}
    begin
      file = Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_redirections.yml",'r')
      redirections = YAML.load(file.read)
    rescue
      Site.all.collect{|item| redirections["site_#{item.to_param}"]={}}
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_redirections.yml",'w') do |f|
        f.write redirections.to_yaml
      end
    end
    redirections
  end

  def self.og_redirections=(value)
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_redirections.yml",'w') do |f|
      f.write value.to_yaml
    end
  end

  def self.og_metas
    metas = {}
    begin
      file = Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_metas.yml",'r')
      metas = YAML.load(file.read)
    rescue
      Site.all.collect{|item| metas["site_#{item.to_param}"]={}}
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_metas.yml",'w') do |f|
        f.write metas.to_yaml
      end
    end
    metas
  end

  def self.og_metas=(value)
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_metas.yml",'w') do |f|
      f.write value.to_yaml
    end
  end

  def self.og_conversions
    conversions = {}
    begin
      file = Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_conversions.yml",'r')
      conversions = YAML.load(file.read)
    rescue
      Site.all.collect{|item| conversions["site_#{item.to_param}"]={}}
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_conversions.yml",'w') do |f|
        f.write conversions.to_yaml
      end
    end
    conversions
  end

  def self.og_conversions=(value)
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/og_conversions.yml",'w') do |f|
      f.write value.to_yaml
    end
  end

  def self.robots site_id
    begin
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'r')
    rescue
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'w') do |f|
        f.write "# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file\n#\n# To ban all spiders from the entire site uncomment the next two lines:\n# User-Agent: *\n# Disallow: /"
      end
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'r')
    end
  end

  def self.set_robots(value,site_id)
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'w') do |f|
      f.write value
    end
  end

  def self.sitemap site_id
    begin
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/sitemap.xml",'r')
    rescue
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/sitemap.xml",'w') do |f|
#        f.write Zlib::Deflate.deflate("<?xml version=\"1.0\" encoding=\"UTF-8\"?><?xml-stylesheet type=\"text/xsl\" href=\"gss.xsl\"?><urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.google.com/schemas/sitemap/0.84 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\"></urlset>")
        f.write "<?xml version=\"1.0\" encoding=\"UTF-8\"?><urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.google.com/schemas/sitemap/0.84 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\"></urlset>"
      end
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/sitemap.xml",'r')
    end
  end

  def self.set_sitemap value,site_id,gzip
    # Save only gzip
    Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/sitemap.xml",'w') do |f|
      f.write(gzip ? value : Zlib::Deflate.deflate(value))
    end
  end
end
