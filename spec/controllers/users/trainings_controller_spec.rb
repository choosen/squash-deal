require 'rails_helper'

RSpec.describe Users::TrainingsController, type: :controller do
  login_user
  let(:user) { FactoryGirl.create(:user) }
  let(:training) { FactoryGirl.create(:training) }

  describe 'GET #index.json' do
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
    let(:users_training) { FactoryGirl.create(:users_training) }
    let(:valid_params) do
      users_training.attributes.slice('user_id').
        symbolize_keys.merge(attended: true, id: users_training.training.id)
    end
    let(:invalid_params) { valid_params.slice(:user_id).merge(id: -5) }

    context 'with valid params' do
      subject { put :update, params: valid_params }

      context 'when users_training is not marked as attended' do
        it 'updates the users_training' do
          expect { subject }.to change { users_training.reload.attended }
        end

        it 'redirects to the training and flash success' do
          subject
          expect(response).to redirect_to(UsersTraining.last.training)
          expect(flash[:success]).to eq 'User training info updated'
        end
      end

      context 'when users_training is marked as attended' do
        let(:ut_attended) do
          FactoryGirl.create(:users_training, attended: true)
        end
        let(:valid_params) do
          ut_attended.attributes.slice('user_id').symbolize_keys.
            merge(attended: false, id: ut_attended.training.id)
        end

        it 'updates the users_training' do
          expect { subject }.to change { ut_attended.reload.attended }
        end

        it 'redirects to the training and flash success' do
          subject
          expect(flash[:success]).to eq 'User training info updated'
          expect(response).to redirect_to(ut_attended.training)
        end
      end
    end

    context 'with invalid params' do
      subject { put :update, params: invalid_params }

      it "doesn't change users_training" do
        expect { subject }.not_to change { users_training.reload.attended }
      end

      it 'redirects to the root with flash' do
        subject
        expect(flash[:error]).to eq 'Error during update'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
