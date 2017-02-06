require 'rails_helper'

RSpec.describe Users::TrainingsController, type: :controller do
  login_user
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET #index.json' do
    it 'returns http success' do
      get :index, params: { user_id: user.id }, format: :json
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'POST #create' do
    let(:users_training) do
      FactoryGirl.build(:users_training, user: controller.current_user)
    end
    let(:valid_params) do
      users_training.attributes.slice('user_id', 'training_id').symbolize_keys
    end
    let(:wrong_params) { valid_params.slice(:user_id) }

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
                                users_training: wrong_params }
      end

      it "doesn't create a new Training" do
        expect { subject }.not_to change { UsersTraining.count }
      end

      it 'redirects to root with flash' do
        subject
        expect(response).to redirect_to(root_path)
        expect(controller).to set_flash[:notice]
      end
    end
  end

  describe 'PUT #update' do
    [:attended, :multisport_used].each do |field|
      let(:users_training) do
        FactoryGirl.create(:users_training, user: controller.current_user)
      end

      context "with #{field} in params" do
        let(:route_params) do
          { id: users_training.training.id, user_id: users_training.user.id }
        end
        let(:valid_params) do
          { users_training: users_training.attributes.slice('user_id').
            symbolize_keys.merge(field => true) }.merge(route_params)
        end
        let(:wrong_params) do
          { users_training: { field => 1 } }.merge(id: 0, user_id: 5)
        end

        context 'with valid params' do
          subject { put :update, params: valid_params }

          context "when users_training is not marked as #{field}" do
            it 'updates the users_training' do
              expect { subject }.to change { users_training.reload.send(field) }
            end

            it 'redirects to the training and flash success' do
              subject
              expect(flash[:success]).to eq 'User training info updated'
              expect(response).to redirect_to(UsersTraining.last.training)
            end
          end

          context "when users_training is marked as #{field}" do
            login_user :user_with_multi

            let(:ut_attended) do
              FactoryGirl.create(
                :users_training, field => true, user: controller.current_user
              )
            end
            let(:route_params) do
              { id: ut_attended.training.id, user_id: ut_attended.user.id }
            end
            let(:valid_params) do
              { users_training: { field => false } }.merge(route_params)
            end

            it 'updates the users_training' do
              expect { subject }.to change { ut_attended.reload.send(field) }
            end

            it 'redirects to the training and flash success' do
              subject
              expect(flash[:success]).to eq 'User training info updated'
              expect(response).to redirect_to(ut_attended.training)
            end
          end
        end

        context 'with invalid params' do
          subject { put :update, params: wrong_params }

          it "doesn't change users_training" do
            expect { subject }.
              not_to change { users_training.reload.send(field) }
          end

          it 'redirects to the root with flash' do
            subject
            expect(controller).to set_flash[:error]
            expect(response).to redirect_to(root_path)
          end
        end
      end
    end
  end
end
