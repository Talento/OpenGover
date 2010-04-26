class User
  include MongoMapper::Document
  include Slug
  
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation
  AVAILABLE_ROLES = %w[none all admin moderator author banned]
  ROLE_ALL = %w[all]
  ROLE_NONE = %w[none]
  ROLES = AVAILABLE_ROLES - ROLE_ALL - ROLE_NONE

  key :roles, Array, :default => %w[all]

  slug :email_name

  before_save :set_user_rol
  after_create :set_initial_user_rol

  def is?(role)
    !role.blank? && roles.include?(role.to_s)
  end

  def email_name
    email.gsub(/\@.*/,"")
  end

  def role
    "user-#{self.id}"
  end

  private

  def set_user_rol
    self.roles << self.role unless self.roles.include?(self.role) || self.new?
  end
  def set_initial_user_rol
    self.roles << self.role unless self.roles.include?(self.role)
    self.save
  end

end
