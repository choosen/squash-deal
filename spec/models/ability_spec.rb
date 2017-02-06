require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  describe 'abilities' do
    let(:user) { nil }
    let(:expected) { RSpec::Expectations::ExpectationNotMetError }

    subject(:ability) { Ability.new(user) }

    context 'when user is guest' do
      it { is_expected.not_to be_able_to(:manage, :all) }
    end

    context 'when user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'when user is player' do
      let(:user) { create(:user) }
      let(:other_user_training_ut) { create(:users_training) }
      let(:other_user_training) { other_user_training_ut.training }
      let(:other_user) { create(:user) }
      let(:owned_training_ut) { create(:users_training, user: user) }
      let(:owned_training) { owned_training_ut.training }

      it { is_expected.to be_able_to(:read, :all) }

      it { is_expected.to be_able_to(:manage, user) }
      it { is_expected.not_to be_able_to([:edit, :update], other_user) }

      it { is_expected.to be_able_to(:create, Training) }

      context 'when training belongs to other user' do
        it { is_expected.not_to be_able_to(:manage, other_user_training) }
        it { is_expected.not_to be_able_to(:update, other_user_training_ut) }
      end

      context 'when training belongs to him' do
        it { is_expected.to be_able_to(:manage, owned_training) }
        it { is_expected.to be_able_to(:update, owned_training_ut) }
      end

      context 'when users_training belong to him' do
        it do
          is_expected.not_to be_able_to(:reaction_to_invite,
                                        other_user_training_ut)
        end
      end

      context 'when users_training belong to other user' do
        it { is_expected.to be_able_to(:reaction_to_invite, owned_training_ut) }
      end
    end
  end
end
