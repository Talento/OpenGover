module OgSeoOptimizer
#  mattr_accessor :og_redirections
  @@og_redirections = {}

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

  def self.robots site_id
    begin
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'r')
    rescue
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'w') do |f|
        f.write " "
      end
      Mongo::GridFileSystem.new(MongoMapper.database).open("/static_files/site_#{site_id}/robots.txt",'r')
    end
  end
end
