require 'lingua/stemmer'

class SearchController < ApplicationController
  
  def reindex
    for d in Demotext.all
      d.save
    end
  end
#
#  def search_bak
#    query = ["es", "una"] #params[:query].split(" ")
#
#
#    #The invix creation map function. Splits the texts in individual words
#map_index =<<JS
#  function() {
#    for ( var i=0; i<this.search_terms.length; i++ ) {
#      emit(this.search_terms[i], { docs: [this._id], weight: this.search_terms[i].weight });
#    }
#  }
#JS
#
## Groups the doc id's for every unique word
#reduce_index =<<JS
#  function(key, values) {
#      var docs = [];
#      var calc_weight = 0;
#
#      values.forEach ( function(val) { docs = docs.concat(val.docs); calc_weight = calc_weight + val.weight; })
#
#      return { docs: docs, weight: calc_weight };
#  }
#JS
#
## Every document counts as one
#map_relevance =<<JS
#  function() {
#    calc_weight = this.value.weight;
#   for ( var i=0; i< this.value.docs.length; i++ ) {
#     emit(this.value.docs[i], { count: 1, weight: calc_weight });
#   }
# }
#JS
#
## And calculate the amount of occurrences for every unique document id
#reduce_relevance=<<JS
#  function(key, values) {
#      var sum = 0;
#      var weight = 0;
#
#      values.forEach ( function(val) { sum += val.count; weight += val.weight })
#
#      return { count: sum, weight: weight };
#  }
#JS
#
##calculate the inverted index
##invix_col = doc_col.map_reduce(map_index, reduce_index)
#Rails.logger.fatal "Voy a hacer el invix"
#invix_col = SearchDocument.collection.map_reduce(map_index, reduce_index, { :query => { "search_terms.term" => { "$in" =>  query} }  })
#invix_col.find().each do |result|
#  Rails.logger.fatal "invix with id #{result["_id"]} has docs #{result["value"]["docs"].size()} and weight #{result["value"]["weight"]}"
#end
##calculate the # occcurances of each searchterm
#    Rails.logger.fatal "Hecho el invix"
#
#    ranked_result = invix_col.map_reduce(map_relevance, reduce_relevance, { :query => { "_id.term" => { "$in" =>  query} }  } )
#      Rails.logger.fatal "hechos los resultados"
#
#  Rails.logger.fatal "Obtenidos #{ranked_result.count()} resultados"
#
##output the results, most relevant on top
#ranked_result.find().sort("count", :desc).each do |result|
#  Rails.logger.fatal "document with id #{result["_id"]} has rank #{result["value"]["weight"]} (#{result["value"]["count"]}) : #{SearchDocument.find(result["_id"]).inspect}"
#end
#
#    render :text => ""
#
#   end

  def search
    @search_query = params[:search]
    stemmer= Lingua::Stemmer.new(:language => I18n.locale.to_s)
    query = @search_query.split(" ").collect{|t| stemmer.stem(t.downcase)}
    roles = %w[all]
    roles = current_user.roles if user_signed_in?


    #The invix creation map function. Splits the texts in individual words
map_index =<<JS
  function() {
    for ( var i=0; i<this.s_documents.length; i++ ) {
      emit({s_indexed_document_id: this.s_documents[i].s_indexed_document_id}, { rarity: this.rarity, weight: this.s_documents[i].weight });
    }
  }
JS

# Groups the doc id's for every unique word
reduce_index =<<JS
  function(key, values) {
      var fix = 0;
      var rarity = 0;
      var weight = 0;

      values.forEach ( function(val) { fix += (val.weight * val.rarity); rarity += val.rarity; weight += val.weight })

      return { fix: fix, rarity: rarity, weight: weight};
  }
JS

#calculate the inverted index
#invix_col = doc_col.map_reduce(map_index, reduce_index)
Rails.logger.fatal "Busqueda 2"
ranked_result = STerm.collection.map_reduce(map_index, reduce_index, { :query => { "_id" => { "$in" =>  query}, "s_documents.roles" => { "$in" =>  roles} }  })
#invix_col.find().each do |result|
#  Rails.logger.fatal "invix with id #{result["_id"]} has docs #{result["value"]["docs"].size()} and weight #{result["value"]["weight"]}"
#end
#calculate the # occcurances of each searchterm
#    Rails.logger.fatal "Hecho el invix"

#    ranked_result = invix_col.map_reduce(map_relevance, reduce_relevance, { :query => { "_id.term" => { "$in" =>  query} }  } )
      Rails.logger.fatal "hechos los resultados"

  Rails.logger.fatal "Obtenidos #{ranked_result.count()} resultados"


#output the results, most relevant on top
ranked_result.find().sort("fix", :desc).each do |result|

    Rails.logger.fatal "--------------------------------------"
    Rails.logger.fatal "--------------------------------------"

    Rails.logger.fatal result.inspect

    Rails.logger.fatal "--------------------------------------"
    Rails.logger.fatal "--------------------------------------"
    
  Rails.logger.fatal "document with id #{result["_id"]} has rank #{result["value"]["fix"]} : #{SearchDocument.find(result["_id"]).inspect}"
end

    per_page = 10
    @current_page =params[:page] || 1
    @results = ranked_result.find().limit(per_page).skip((@current_page-1)*per_page).sort("fix", :desc)
    @total_results = ranked_result.count()
    @total_pages = @total_results % per_page == 0 ? @total_results / per_page.to_f : @total_results / per_page.to_i + 1

   end

end
