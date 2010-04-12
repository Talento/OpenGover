
module OgBaseHelper
    def link_to_page(page, options={})
#logger.fatal("-------------------------------")
#logger.fatal(page.name)
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
end

ActionView::Base.send(:include, OgBaseHelper)