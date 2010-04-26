# Methods added to this helper will be available to all templates in the application.
module SearchHelper

  def link_for_search_result(indexed_doc_id)
      i_doc = SIndexedDocument.find(indexed_doc_id)
      link_to i_doc.title, url_for_search_result(i_doc.doc_type, i_doc.doc_id)
  end

  def url_for_search_result(doc_type, doc_id)
    begin
     doc = doc_type.singularize.camelize.constantize.find(doc_id)
     return url_for(doc.url)
    rescue
     return url_for(:controller => doc_type.downcase.pluralize, :action => :show, :id => doc_id)
    end
  end

end
