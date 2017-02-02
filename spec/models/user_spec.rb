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
end
