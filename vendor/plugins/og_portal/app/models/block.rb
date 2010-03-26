class Block

  include Mongoid::Document
  field :name

  belongs_to :template, :inverse_of => :blocks
  has_many :embedded_applications

  validates_presence_of :name

end