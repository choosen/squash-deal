module UsersHelper
  def formatted_user_name(user)
    return 'missing' if user.name.blank?
    user.name
  end
end
