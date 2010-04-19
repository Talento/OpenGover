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

  def is?(role)
    !role.blank? && roles.include?(role.to_s)
  end

  def email_name
    email.gsub(/\@.*/,"")
  end

end
