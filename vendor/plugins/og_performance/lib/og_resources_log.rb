module MongoMapper
  module Plugins
    module OgResourcesLog

      module ClassMethods

        def find_one(options={})
          criteria, query_options = to_query(options)

          if simple_find?(criteria)
            ResourceLog.add_resource(self.name, criteria[:_id])
          end
          super
        end

        def find_many(options)
          ResourceLog.add_resource(self.name, :all)
          super
        end

        private

          def simple_find?(criteria)
            criteria.keys == [:_id] || criteria.keys.to_set == [:_id, :_type].to_set
          end

      end

      module InstanceMethods
        def save(*args)
          if result = super
            ResourceLog.clear_cache_for(self.class.name, _id)
          end
          result
        end

        def delete
            ResourceLog.clear_cache_for(self.class.name, _id)
          super
        end
      end
    end
  end
end



module OgResourcesLogAddition
  def self.included(model)
    model.plugin MongoMapper::Plugins::OgResourcesLog
  end
end

MongoMapper::Document.append_inclusions(OgResourcesLogAddition)