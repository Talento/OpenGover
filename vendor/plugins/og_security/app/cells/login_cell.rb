class LoginCell < Cell::Base

  include Devise::Controllers::Helpers

  embedded_application(:name => "User login", :cell_name => "login", :cell_state => "user_login", :cell_params => {})

  def user_login
      render
  end
end
