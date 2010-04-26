# encoding: utf-8

require 'lingua/stemmer'

module Searchable
  def self.included(base)
    base.send :extend, ClassMethods
    base.class_eval do
    end
  end

  module ClassMethods
    def searchable(field_for_title, fields_for_search={})
      cattr_accessor :title_field
      self.title_field = field_for_title

      cattr_accessor :search_fields
      self.search_fields = fields_for_search

      after_save :set_search_document
      before_destroy :destroy_search_document

      send :include, InstanceMethods
    end
  end

  module InstanceMethods

    private

    def set_search_document

#    search_document = SearchDocument.first(:doc_type => self.class.name, :doc_id => self.id) || SearchDocument.new(:doc_type => self.class.name, :doc_id => self.id)
#    search_document.search_terms = []
#
#    term_map = {}
#    search_fields.each_pair do |field, weight|
#      value = self.send(field)
#      unless value.blank?
#        for term in value.split
#          if term_map[term].blank?
#            term_map[term] = weight
#          else
#            term_map[term] += weight
#          end
#        end
#      end
#    end
#
#    term_map.each_pair do |term, weight|
#      fixed_weight = weight>100 ? 100 : weight
#      search_document.search_terms << SearchTerm.new(:term => term, :weight => fixed_weight, :rarity => 1)
#    end
#
#    search_document.save


      #Version 2
      clear_references

      s_title = self.send(title_field)
      s_indexed_doc = SIndexedDocument.create(:doc_type => self.class.name, :doc_id => self.id, :title => s_title)

      stemmer= Lingua::Stemmer.new(:language => I18n.locale.to_s)

      term_map = {}
      search_fields.each_pair do |field, weight|
        value = self.send(field)
        unless value.blank?
          for term in value.split
            stemmed_term = stemmer.stem(term.downcase)
            if term_map[stemmed_term].blank?
              term_map[stemmed_term] = weight
            else
              term_map[stemmed_term] += weight
            end
          end
        end
      end

      num_docs = SIndexedDocument.count()
      term_map.each_pair do |term, weight|
        fixed_weight = weight>100 ? 100 : weight
        s_term = STerm.find(term) || STerm.new(:id => term)
        term_docs = s_term.s_documents.size + 1
        Rails.logger.fatal "----------------"
        Rails.logger.fatal "--- num_docs: #{num_docs}, term_docs: #{term_docs}"
        Rails.logger.fatal "--- sin log: #{(num_docs.to_f - term_docs.to_f + 0.5) / (term_docs.to_f + 0.5)}"
        Rails.logger.fatal "----------------"
        if (num_docs.to_f - term_docs.to_f + 0.5) / (term_docs.to_f + 0.5) > 0
          s_term.rarity = Math.log((num_docs.to_f - term_docs.to_f + 0.5) / (term_docs.to_f + 0.5))
        else
          s_term.rarity = 0
        end
        if self.respond_to?(:roles)
          s_term.s_documents << SDocument.new(:s_indexed_document_id => s_indexed_doc.id, :weight => fixed_weight, :roles => self.roles)
        else
          s_term.s_documents << SDocument.new(:s_indexed_document_id => s_indexed_doc.id, :weight => fixed_weight)
        end
        s_term.save
      end

    end

    def destroy_search_document
#      SearchDocument.delete_all(:doc_type => self.class.name, :doc_id => self.id)

      #Version 2
      clear_references
    end


    def clear_references
      for s_indexed_doc in SIndexedDocument.all(:doc_type => self.class.name, :doc_id => self.id.to_s)
        for sterm in STerm.all(:'s_documents.s_indexed_document_id' => s_indexed_doc.id)
          sterm.s_documents = sterm.s_documents.reject {|s_doc|  s_doc.s_indexed_document_id == s_indexed_doc.id }
          sterm.save
        end
        s_indexed_doc.destroy
      end
    end

  end
end

