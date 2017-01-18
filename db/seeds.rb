def add_user(email, password)
  @user = User.invite!(:email => email) do |u|
    u.skip_invitation = true
  end
  token = Devise::VERSION >= "3.1.0" ? @user.instance_variable_get(:@raw_invitation_token) : @user.invitation_token
  User.accept_invitation!(:invitation_token => token, :password => password, :password_confirmation => password)

  puts "Created User #{email} with password #{password}"
  @user
end

admin = add_user('admin@sample.com', "12345678")
admin.admin = true
admin.save

player = add_user('player@sample.com', '12345678')

training = Training.create(date: DateTime.now, price: 120.00)
training.users << player
