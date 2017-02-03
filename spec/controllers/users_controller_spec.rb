require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    context 'himself' do
      it 'returns http success' do
        get :edit, params: { id: controller.current_user.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'another user' do
      context 'logged as admin' do
        login_user :admin

        it 'returns http success' do
          get :edit, params: { id: user.id }
          expect(response).to have_http_status(:success)
        end
      end

      context 'logged as user,' do
        it 'flash error and redirect' do
          get :edit, params: { id: user.id }
          expect(controller).to set_flash[:notice]
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
