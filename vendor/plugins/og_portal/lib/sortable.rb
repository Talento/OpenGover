# encoding: utf-8

module Sortable
  def self.included(base)
    base.send :extend, ClassMethods
    base.class_eval do
    end
  end

  module ClassMethods
    def sortable(field_for_scope="")
      cattr_accessor :order_scope_field
      self.order_scope_field = field_for_scope

      key :position, Integer
      before_create :set_initial_position
      before_destroy :reorder_positions

      send :include, InstanceMethods
    end
  end

  module InstanceMethods

  def move_higher
    p = self.class.first(:position => self.position-1, :parent_id => self.parent_id)
    p.position += 1
    p.save

    self.position -= 1
    self.save
  end

  def move_lower
    p = self.class.first(:position => self.position+1, :parent_id => self.parent_id)
    p.position -= 1
    p.save

    self.position += 1
    self.save
  end
  
    private

  def set_initial_position
    self.position = self.class.count(:parent_id => self.parent_id) + 1
  end

    def reorder_positions
#      hash = {}
#      for s in self.class.all(:select => "id,position", :position.gt => self.position, :parent_id => self.parent_id)
#        hash[s.id] = {:position => s.position - 1}
#      end
#      self.class.update(hash)

      s = self.class.all(:select => "id", :position.gt => self.position, :parent_id => self.parent_id)
      unless s.blank?
      # ids is array of item ids
conditions = {:_id => {'$in' => s.collect(&:id)}}

# amount is either 1 or -1 for increment and decrement
increments = {'$inc' => {:position => -1}}

collection.update(conditions, increments, :multi => true)
        end
    end

  end
end

