module UsersHelper
  def formatted_user_name(user)
    user.name || 'missing'
  end
end
