
module OgBaseHelper
    def link_to_page(page, options={})
        pagina = page.name
        if page.link.blank?
            link_to(raw("<span>"+pagina+"</span>"), page.url, options)
        else
            if page.link.starts_with?("/")
                link_to(raw("<span>"+pagina+"</span>"), page.link, options)
            else
                raw("<a title='#{pagina}' onclick=\"window.open(this.href);return false;\" href='#{page.url}'>#{pagina}</a>")
            end
        end
    end

	def uniq_url(url)
         if url.include?("?")
           url + rand(999999).to_s
         else
           url + "?" + rand(999999).to_s
         end
	end
end

ActionView::Base.send(:include, OgBaseHelper)