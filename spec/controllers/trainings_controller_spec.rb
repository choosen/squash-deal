require 'rails_helper'

RSpec.describe TrainingsController, type: :controller do
  login_user
  let(:training) { FactoryGirl.create(:training) }

  let(:valid_attributes) { { date: DateTime.current + 2.days, price: 212 } }
  let(:invalid_attr) { { price: -5 }.merge(a: 1) }

  describe 'GET #index' do
    context 'html' do
      render_views

      it 'renders the index template' do
        controller.prepend_view_path 'app/views/trainings'
        get :index
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('text/html')
        expect(response.body).to match(/Listing trainings/)
      end
    end

    context 'json' do
      it 'renders the index json' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested training as @training' do
      get :show, params: { id: training.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'assigns a new training as @training' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested training as @training' do
      get :edit, params: { id: training.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      subject { post :create, params: { training: valid_attributes } }

      it 'creates a new Training' do
        expect { subject }.to change { Training.count }.by(1)
      end

      it 'redirects to the created training' do
        expect(subject).to redirect_to(Training.last)
      end

      it 'expect flash notice' do
        subject
        expect(controller).to set_flash[:notice]
      end
    end

    context 'with invalid params' do
      subject { post :create, params: { training: invalid_attr } }

      it "doesn't create a new Training" do
        expect { subject }.not_to change { Training.count }
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      before(:each) do
        @training = create(:training)
      end
      let!(:par) { { date: DateTime.current + 1.day, price: 1890.00 } }

      subject { put :update, params: { id: @training.to_param, training: par } }

      it 'updates the requested training' do
        expect { subject }.to change { @training.reload.price }
      end

      it 'redirects to the training' do
        subject
        expect(response).to redirect_to(@training)
      end

      it 'expect flash notice' do
        subject
        expect(controller).to set_flash[:notice]
      end
    end

    context 'with invalid params' do
      subject do
        put :update, params: { id: training.to_param, training: invalid_attr }
      end

      it "doesn't update the requested training" do
        expect { subject }.not_to change { training.reload.price }
      end

      it "re-renders the 'edit' template" do
        subject
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:training_to_destroy) { create(:training) }
    subject { delete :destroy, params: { id: training_to_destroy.to_param } }

    it 'destroys the requested training' do
      # expect { subject }.to change(Training, :count).by(-1)
      expect { subject }.to change { Training.count }.by(-1)
    end

    it 'redirects to the trainings list' do
      subject
      expect(response).to redirect_to(trainings_url)
    end
  end
end
