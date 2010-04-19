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
    if self.order_scope_field.blank?
      p = self.class.first(:position => self.position-1, self.order_scope_field.to_sym => self.send(self.order_scope_field))
    else
      p = self.class.first(:position => self.position-1)
    end
    p.position += 1
    p.save

    self.position -= 1
    self.save
  end

  def move_lower
    if self.order_scope_field.blank?
      p = self.class.first(:position => self.position+1, self.order_scope_field.to_sym => self.send(self.order_scope_field))
    else
      p = self.class.first(:position => self.position+1)
    end
    p.position -= 1
    p.save

    self.position += 1
    self.save
  end
  
    private

  def set_initial_position
    if self.order_scope_field.blank?
    self.position = self.class.count(self.order_scope_field.to_sym => self.send(self.order_scope_field)) + 1
    else
      self.position = self.class.count() + 1
      end
  end

    def reorder_positions
#      hash = {}
#      for s in self.class.all(:select => "id,position", :position.gt => self.position, :parent_id => self.parent_id)
#        hash[s.id] = {:position => s.position - 1}
#      end
#      self.class.update(hash)

    if self.order_scope_field.blank?
      s = self.class.all(:select => "id", :position.gt => self.position, self.order_scope_field.to_sym => self.send(self.order_scope_field))
    else
      s = self.class.all(:select => "id", :position.gt => self.position)
    end
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

