require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#formatted_user_name' do
    let(:user) { build(:user, name: 'Player') }

    subject { helper.formatted_user_name(user) }

    context 'when name is given' do
      it { is_expected.to eq user.name }
    end

    context 'when name is nil' do
      let(:user) { build(:user, name: nil) }

      it { is_expected.to eq 'missing' }
    end

    context 'when name is blank' do
      let(:user) { build(:user, name: '') }

      it { is_expected.to eq 'missing' }
    end
  end
end
