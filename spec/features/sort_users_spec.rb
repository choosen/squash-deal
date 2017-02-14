require 'rails_helper'

RSpec.feature 'Sort users', type: :feature do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  scenario 'User sort user list by email' do
    user
    sign_in

    visit users_path

    click_link 'E-mail', exact: true
    expect(page.all('tr')[1].text).to include('admin@example.com')

    click_link 'E-mail', exact: true
    expect(page.all('tr')[2].text).to include('admin@example.com')
  end
end
