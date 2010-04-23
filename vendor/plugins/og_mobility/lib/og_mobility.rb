class OgMobility
  # Different mobile browsers
  OG_MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  # Tags nos accepted in mobile version
  OG_UNACCEPTED_MOBILE_TAGS = ["object"]
  # Never delete tags with this class
  OG_ACCEPTED_CLASS = ["mobile_img"]
  # CSS nor accepted in mobile version
  OG_UNACCEPTED_CSS = ["nomobile"]

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    if headers['Content-Type'] && headers['Content-Type'].include?('text/html') && !(OG_MOBILE_BROWSERS.find{|item| env['HTTP_USER_AGENT'].downcase=~Regexp.new(item)}).blank?
      response.body = og_mobile_version response.body
      headers['Content-Length'] = response.body.length.to_s
    end
    [status, headers, response]
  end

  def og_mobile_version body
    r_textarea = Regexp.new(/<textarea([^>]*?)>([^<]*?)<\/textarea>/)
    textarea =  body.scan r_textarea
    # Delete whitespaces...
    body.gsub!(/(\s){2,}/m,' ')
    # ...unless textarea
    textarea_mod =  body.scan r_textarea
    for i in (0..textarea.length-1)
      body.gsub! textarea_mod[i][1], textarea[i][1]
    end
    # Delete images inside body
    body = og_clean_html_for_mobile(body)
    # Delete tags not accepted
    body = og_clean_unaccepted_tags_for_mobile(body)
    # Load CSS for mobile
    body = og_load_mobile_css(body)
    Rails.logger.fatal "---------------------"
    body
  end

  def og_clean_unaccepted_tags_for_mobile body
    for tag in OG_UNACCEPTED_MOBILE_TAGS
      body.gsub("<#{tag}([^>]*?)>(.*)?</#{tag}>",'') {
        tag_content = $1.clone
        tag_html = $2.clone
        result = ""
        unless (OG_ACCEPTED_CLASS.find{|item| tag_content=~Regexp.new(item)}).blank?
          result = "<#{tag}#{tag_content}>#{tag_html}</tag>"
        end
        result
      }
    end
    body
  end

 # Clean images in the code
 def og_clean_html_for_mobile body
   body = body.gsub(/<a([^>]*?)><img([^>]*?)\/><\/a>/im) {
     a_content = $1.clone
     img_content = $2.clone
     unless (OG_ACCEPTED_CLASS.find{|item| img_content=~Regexp.new(item)}).blank?
        "<a#{a_content}><img#{img_content}/></a>"
     else
        title =""
        a_content.gsub(/title="([^>]*?)"/im){title = $1.clone}
        img_content.gsub(/alt="([^>]*?)"/im){title = $1.clone} if title.blank?
        title = "NO TITLE" if title.blank?
        "<a#{a_content}>#{title}</a>"
     end
   }
   body = body.gsub(/<img([^>]*?)\/>/im) {
     img_content = $1.clone
     unless (OG_ACCEPTED_CLASS.find{|item| img_content=~Regexp.new(item)}).blank?
        "<img#{img_content}/>"
     else
        title =""
        img_content.gsub(/alt="([^>]*?)"/im){title = $1.clone}
        title = "NO TITLE" if title.blank?
        "#{title}"
     end
   }
   body
 end

 def og_load_mobile_css body
   body.gsub!(/<link href="([^"]*?)"([^>]*?)rel="stylesheet"([^>]*?)\/>/){
      stylesheet = $1.clone
      c1 = $2.clone
      c2 = $3.clone
      result = ""
      if (OG_UNACCEPTED_CSS.find{|item| stylesheet=~Regexp.new(item)}).blank?
        result = "<link href=\"#{stylesheet.gsub(/\/([^\/]*?)$/,"/mobile_#{$1}")}\"#{c1}rel=\"stylesheet\"#{c2}/>"
      end
     result
   }
   body
 end

end