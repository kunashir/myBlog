class OnlyAdmins < ActiveAdmin::AuthorizationAdapter
  # attr_accessible :title, :body
  def authorized?(action, subject = nil)
    user.admin?
  end
end
