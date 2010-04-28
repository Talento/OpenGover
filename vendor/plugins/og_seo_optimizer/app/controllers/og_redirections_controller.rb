class OgRedirectionsController < ApplicationController

#
  def fix_dir(d)
    d.sub!(%r(/(.*?))){"#{$1}"} if d.starts_with?("/")
    d.sub!(%r((.*?)/)){"#{$1}"} if d.ends_with?("/")
    d
  end
#
  def reload_configurations(confs)
    red = {}
    for k in confs.keys
      red["#{k}"]= confs[k]
    end
    aux = OgSeoOptimizer.og_redirections
    aux["site_#{params[:og_site].id}"]={} if aux["site_#{params[:og_site].id}"].nil?
    aux["site_#{params[:og_site].id}"][params[:og_locale]] = red
    OgSeoOptimizer.og_redirections = aux
  end

  def reload_metas(confs)
    red = {}
    for k in confs.keys
      k.blank? ? aux_k="(blank)" : aux_k = k
      red["#{aux_k}"]= confs[k].gsub(/\r\n/m,"@n@").gsub(":","@2p@")
    end
    aux = OgSeoOptimizer.og_metas
    aux["site_#{params[:og_site].id}"]={} if aux["site_#{params[:og_site].id}"].nil?
    aux["site_#{params[:og_site].id}"][params[:og_locale]] = red
    OgSeoOptimizer.og_metas = aux
  end

  def reload_conversions(confs)
    red = {}
    for k in confs.keys
      k.blank? ? aux_k="(blank)" : aux_k = k
      red["#{aux_k}"]= confs[k].gsub(/\r\n/m,"@n@").gsub(":","@2p@")
    end
    aux = OgSeoOptimizer.og_conversions
    aux["site_#{params[:og_site].id}"]={} if aux["site_#{params[:og_site].id}"].nil?
    aux["site_#{params[:og_site].id}"][params[:og_locale]] = red
    OgSeoOptimizer.og_conversions = aux
  end
#
#  def write_htaccess(confs)
#    Dir.mkdir "#{Rails.public_path}/redirections/site#{Cms.site.id}/" rescue 0
#    f = File.open("#{Rails.public_path}/redirections/site#{Cms.site.id}/.htaccess", "w") do |file|
#      file << %{#{confs}}
#    end
#    File.delete("#{Rails.public_path}/.htaccess") if File.exists?"#{Rails.public_path}/.htaccess"
#    File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/.htaccess","#{Rails.public_path}/.htaccess")
#
#  end
#
#  def write_exclusion id
#    Dir.mkdir "#{Rails.public_path}/redirections/site#{Cms.site.id}/" rescue 0
#    f = File.open("#{Rails.public_path}/redirections/site#{Cms.site.id}/exclusion.html", "w") do |file|
#      file << %{
#            <html><head></head><body>
#            <div onload="javascript:pageTracker._setVar('test_value');">
#            A partir de este momento, las visitas realizadas desde este ordenador nose tendr&aacute;n en cuenta para las estad&iacute;sticas de su web.
#            <!--Inicio Codigo de Analytics-->
#            <script type="text/javascript">
#              var gaJsHost = (("https:" == document.location.protocol) ? <a class="moz-txt-link-rfc2396E" href="https://ssl.">"https://ssl."</a> : <a class="moz-txt-link-rfc2396E" href="http://www.">"http://www."</a>);
#              document.write(unescape("%3Cscript src='" + gaJsHost + "<a href="http://google-analytics.com/ga.js'">google-analytics.com/ga.js'</a> type='text/javascript'%3E%3C/script%3E"));
#            </script>
#            <script type="text/javascript">
#              try \{
#                var pageTracker = _gat._getTracker("#{id}");
#                pageTracker._trackPageview();
#              \} catch(err) \{\}
#              </script>
#            <!--Fin Codigo de Analytics-->
#            </div>
#            </body></html>
#      }
#    end
#    File.delete("#{Rails.public_path}/exclusion.html") if File.exists?"#{Rails.public_path}/exclusion.html"
#    File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/exclusion.html","#{Rails.public_path}/exclusion.html")
#  end
#
#  def write_sitemap(sitemap)
#    Dir.mkdir "#{Rails.public_path}/redirections/site#{Cms.site.id}/" rescue 0
#    if sitemap.original_filename.split('.').last.downcase.eql?"xml"
#      f = File.open("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml", "w") do |file|
#        file << sitemap.read
#      end
#      File.delete("#{Rails.public_path}/sitemap.xml") if File.exists?"#{Rails.public_path}/sitemap.xml"
#      File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml","#{Rails.public_path}/sitemap.xml")
#      system("gzip #{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml -c > #{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml.gz")
#      File.delete("#{Rails.public_path}/sitemap.xml.gz") if File.exists?"#{Rails.public_path}/sitemap.xml.gz"
#      File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml.gz","#{Rails.public_path}/sitemap.xml.gz")
#    else
#      f = File.open("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml.gz", "w") do |file|
#        file << sitemap.read
#      end
#      File.delete("#{Rails.public_path}/sitemap.xml.gz") if File.exists?"#{Rails.public_path}/sitemap.xml.gz"
#      File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml.gz","#{Rails.public_path}/sitemap.xml.gz")
#      system("gunzip #{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml.gz -c > #{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml")
#      File.delete("#{Rails.public_path}/sitemap.xml") if File.exists?"#{Rails.public_path}/sitemap.xml"
#      File.symlink("#{Rails.public_path}/redirections/site#{Cms.site.id}/sitemap.xml","#{Rails.public_path}/sitemap.xml")
#    end
#  end
#
#
#  public
#  #	# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  #	verify :method => :post, :only => [ :destroy, :create, :update ],
#  #		 :redirect_to => { :action => :list }
#
#  def self.default_access(action_name, user, objeto)
#    action_name=="description" || action_name=="conversion" ? true : false
#  end
#
  def index
    if request.post?
      @redirections = {}
      @redirections["enabled"] = params[:redirections_enabled]
      1.upto(params[:num_redir].to_i) do |n|
        if !params["red_#{n}_from"].blank? && !params["red_#{n}_to"].blank?
          @redirections[fix_dir(params["red_#{n}_from"])] = fix_dir(params["red_#{n}_to"])
        end
      end
      if !params[:new_from].blank? && !params[:new_to].blank?
        @redirections[fix_dir(params[:new_from])] = fix_dir(params[:new_to])
      end
      reload_configurations(@redirections)
    else
      @redirections = OgSeoOptimizer.og_redirections["site_#{params[:og_site].id}"][params[:og_locale]]
    end
  end

  # Generate metas for page headers
  def index_metas
    if request.post?
      @metas = {}
      @metas["enabled"] = params[:metas_enabled]
      1.upto(params[:num_metas].to_i) do |n|
        if !params["meta_#{n}_url"].blank? || !params["meta_#{n}"].blank?
          @metas[fix_dir(params["meta_#{n}_url"])] = params["meta_#{n}"]
        end
      end
      if !params[:new_url].blank? || !params[:new].blank?
        @metas[fix_dir(params[:new_url])] = fix_dir(params[:new])
      end
      reload_metas(@metas)
    else
      @metas = OgSeoOptimizer.og_metas["site_#{params[:og_site].id}"][params[:og_locale]]
    end
  end

  def index_conversions
    if request.post?
      @conversions = {}
      @conversions["enabled"] = params[:conversions_enabled]
      1.upto(params[:num_conversions].to_i) do |n|
        if !params["conversion_#{n}_url"].blank? || !params["conversion_#{n}"].blank?
          @conversions[fix_dir(params["conversion_#{n}_url"])] = params["conversion_#{n}"]
        end
      end
      if !params[:new_url].blank? || !params[:new].blank?
        @conversions[fix_dir(params[:new_url])] = fix_dir(params[:new])
      end
      reload_conversions(@conversions)
    else
      @conversions = YAML.load(File.open("#{RAILS_ROOT}/static_files/cms_conversions.yml"))["site#{Cms.site.id}"] rescue {}
    end
  end

  # Generate robots.txt file
  def index_robots
    if request.post?
      OgSeoOptimizer.set_robots params[:robots], params[:og_site].id
      flash[:notice] = t('og_redirections.saved_succesfully', :file => 'robots.txt')
    end
    @sid = params[:og_site].id
    @robots = OgSeoOptimizer.robots(params[:og_site].id).read
  end
#
  # Generate sitemap file
  def index_sitemap
    if request.post?
      if (params[:sitemap].original_filename.downcase.eql?"sitemap.xml.gz") || (params[:sitemap].original_filename.downcase.eql?"sitemap.xml")
        OgSeoOptimizer.set_sitemap params[:sitemap].read,params[:sitemap].original_filename.downcase.split('.').last.eql?('gz'),params[:og_site].id 
        flash[:notice] = t('og_redirections.saved_successfully', :file => params[:sitemap].original_filename.downcase)
      else
        flash[:notice] = t('og_redirections.saved_unsuccessfully', :file => params[:sitemap].original_filename.downcase)
      end
    end
  end
#
#  def index_exclusion
#    if request.post?
#      begin
#        write_exclusion(params[:exclusion])
#        flash[:notice] = "Exclusion creado correctamente"
#      rescue
#        flash[:error] = "Error, el fichero no se ha creado"
#      end
#    end
#  end

#  def conversion
#    conversions = YAML.load(File.open("#{RAILS_ROOT}/static_files/cms_conversions.yml"))["site#{Cms.site.id}"] rescue nil
#    if conversions && conversions["enabled"]=="1"
#      p = request.request_uri.clone
#      p.sub!(%r(/(.*?))){"#{$1}"} if p.starts_with?("/")
#      p.sub!(%r((.*?)/)){"#{$1}"} if p.ends_with?("/")
#      p.sub!(%r(private/(.*?)/),"")
#      p.sub!(%r(site/(.*?)/),"")
#      p.sub!(%r(nocache/),"")
#      p="(blank)" if p.blank? || p=="pages/index"
#      @conversion = conversions[p]
#      @conversion.gsub!("@n@","\n") unless @conversion.blank?
#      @conversion.gsub!("@2p@",":") unless @conversion.blank?
#      if @conversion.blank?
#        render :text => ""
#      else
#        render :layout => false
#      end
#    else
#      render :text => ""
#    end
#  end
#
#  def delete_exclusion
#    File.delete("#{Rails.public_path}/redirections/site#{Cms.site.id}/exclusion.html") if File.exists?"#{Rails.public_path}/redirections/site#{Cms.site.id}/exclusion.html"
#    File.delete("#{Rails.public_path}/exclusion.html") if File.exists?"#{Rails.public_path}/exclusion.html"
#    redirect_to :action => 'index_exclusion'
#  end
#
end
