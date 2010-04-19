  class Image2
    include MongoMapper::Document

    key :name, String
    key :user_id, String
    key :role, String, :default => User::ROLE_NONE


    belongs_to :user


  def before_save
    fghfghfg
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
    RAILS_DEFAULT_LOGGER.fatal "**************************"
  end
  def after_save
    fghfg
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
    RAILS_DEFAULT_LOGGER.fatal "a**************************"
  end


  end