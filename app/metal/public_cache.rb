
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)
require(File.dirname(__FILE__) + "/../../config/initializers/mongomapper") unless defined?(Rails)

class PublicCache

  def self.call(env)
    unless env["PATH_INFO"] =~ /^\/private\/(.+)$/
        begin
          file = Mongo::GridFileSystem.new(MongoMapper.database).open(page_cache_file(env["PATH_INFO"].gsub(/\?.*/,"")),'r')
              [200, {"Content-Type" => file.content_type}, [file.read]]
        rescue
          [404, {"Content-Type" => "text/html"}, ["Not Found"]]
        end
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end

  private

          def self.page_cache_file(path)
            name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
            name << '.html' unless (name.split('/').last || name).include? '.'
            return name
          end

end
