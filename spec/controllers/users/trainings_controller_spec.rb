require 'rails_helper'

RSpec.describe Users::TrainingsController, type: :controller do
  login_user
  let(:user) { FactoryGirl.create(:user) }
  let(:training) { FactoryGirl.create(:training) }

  describe 'GET #index.json' do
    render_views

    it 'returns http success' do
      get :index, params: { user_id: user.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'POST #create' do
    let(:users_training) { FactoryGirl.build(:users_training) }
    let(:valid_params) do
      users_training.attributes.slice('user_id', 'training_id').symbolize_keys
    end
    let(:invalid_params) { valid_params.slice(:user_id) }

    context 'with valid params' do
      subject do
        post :create, params: { user_id: valid_params[:user_id],
                                users_training: valid_params }
      end

      it 'creates a new UsersTraining' do
        expect { subject }.to change { UsersTraining.count }.by(1)
      end

      it 'redirects to the created training' do
        subject
        expect(response).to redirect_to(UsersTraining.last.training)
      end

      it 'expect flash notice' do
        subject
        expect(controller).to set_flash[:success]
        expect(flash[:success]).to eq 'Invitation created'
      end
    end

    context 'with invalid params' do
      subject do
        post :create, params: { user_id: valid_params[:user_id],
                                users_training: invalid_params }
      end

      it "doesn't create a new Training" do
        expect { subject }.not_to change { UsersTraining.count }
      end

      it 'redirects to root with flash' do
        subject
        expect(response).to redirect_to(root_path)
        expect(controller).to set_flash[:error]
      end
    end
  end

  describe 'PUT #update' do
    pending('#TODO')
  end
end
