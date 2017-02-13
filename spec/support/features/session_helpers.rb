module Features
  # Helpers to capybara session control
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
      within('.actions') do
        click_on 'Sign up'
      end
    end

    def activate_signed_up_user_by_email(email)
      user = User.find_by(email: email)
      return unless user.present?
      user.accept_invitation!
    end

    def sign_in_by_email(email, password)
      visit new_user_session_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button 'Log in'
    end

    def sign_in
      user = create(:admin)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
    end

    def logout
      click_on 'Account'
      click_on 'Log out'
    end
  end
end
