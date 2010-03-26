class EmbeddedApplication

  include Mongoid::Document
  field :name
  field :cell_name
  field :cell_state
  field :cell_params, :type => Hash, :default => {}

  belongs_to :block, :inverse_of => :embedded_applications

  validates_presence_of :name, :cell_name, :cell_state

end