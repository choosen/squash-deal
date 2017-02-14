# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :trainings }
  it { is_expected.to have_many :users_trainings }

  context 'when user has blank name' do
    let(:user_without_name) { build(:user) }

    subject { user_without_name }

    describe '#set_name_if_blank' do
      it 'change the name with email before save' do
        expect { subject.save }.to change { subject.name }
      end
    end

    describe '#display_name' do
      it 'returns email' do
        expect(subject.display_name).to eq subject.email
      end
    end
  end

  context 'when user has filled name' do
    let(:user_with_name) { build(:user, name: 'Turbo black') }

    subject { user_with_name }

    describe '#set_name_if_blank' do
      it 'saves without name change' do
        expect { subject.save }.not_to change { subject.name }
      end
    end

    describe '#display_name' do
      it 'returns name' do
        expect(subject.display_name).to eq subject.name
      end
    end
  end

  describe '#create_without_invite' do
    let(:params) { { email: 'test@test.com' } }

    subject { User.create_without_invite(params) }

    it { is_expected.to be_instance_of(User) }
    it 'is confirmed' do
      expect(subject.confirmed?).to eq true
    end

    context 'when email in params is missing' do
      let(:params) { { multisport: true } }

      it 'is not persisted' do
        expect(subject.persisted?).to eq false
      end
    end
  end

  describe '#from_omniauth' do
    let!(:info_hash) { { 'email' => 'test@test.com', 'name' => 'Rob' } }
    let(:user) { create(:user_with_multi, info_hash.symbolize_keys) }
    let(:access_token) { double('access_token', info: info_hash) }

    subject { User.from_omniauth(access_token) }

    context 'when email is new' do
      it { is_expected.to be_instance_of User }

      it 'adds new user' do
        expect { subject }.to change { User.count }.by 1
      end

      it 'set given user name' do
        expect(subject.name).to eq info_hash['name']
      end
    end

    context 'when email is registred' do
      before(:each) do
        user
      end

      it 'returns his user' do
        expect(subject).to eq user
      end

      it "don't add new user" do
        expect { subject }.not_to change { User.count }
      end
    end
  end

  describe 'scope not_invited_to_training' do
    let(:user) { create(:user) }
    let(:training) { create(:training) }

    subject { User.not_invited_to_training(training) }

    it { is_expected.to eq [user] }
  end
end
