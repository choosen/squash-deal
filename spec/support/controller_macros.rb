# methods for signing in in controllers in rspec
module ControllerMacros
  def login_user(factory_mode = nil)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(factory_mode || :user)
      user.confirm
      sign_in user
    end
  end
end
