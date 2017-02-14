require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  describe 'abilities' do
    let(:user) { nil }
    let(:other_user_ut) { create(:users_training) }
    let(:other_user_training) { other_user_ut.training }

    subject(:ability) { Ability.new(user) }

    context 'when user is guest' do
      it { is_expected.not_to be_able_to(:manage, :all) }
    end

    context 'when user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to be_able_to(:manage, :all) }
      it do
        is_expected.not_to be_able_to(:reaction_to_invite,
                                      other_user_ut)
      end

      context 'when training is undone' do
        let(:owned_ut) { create(:users_training, user: user) }

        it 'restrict changing another user training attendance' do
          is_expected.not_to be_able_to(:update, other_user_ut)
        end

        it 'allow changing himself attendance' do
          is_expected.to be_able_to(:update, owned_ut)
        end

        it 'allow invite to training' do
          is_expected.to be_able_to(:invite, other_user_ut.training)
        end
      end

      context 'when training is done' do
        before(:each) do
          Timecop.travel(other_user_ut.training.date + 1.day)
        end

        after(:each) do
          Timecop.return
        end

        it 'restrict invite to training' do
          is_expected.not_to be_able_to(:invite, other_user_ut.training)
        end

        it 'allow changing another user training attendance' do
          is_expected.to be_able_to(:update, other_user_ut)
        end
      end
    end

    context 'when user is player' do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:owned_ut) { create(:users_training, user: user) }
      let(:owned_training) { owned_ut.training }

      it { is_expected.to be_able_to(:read, :all) }

      it { is_expected.to be_able_to(:manage, user) }
      it { is_expected.not_to be_able_to([:edit, :update], other_user) }

      it { is_expected.to be_able_to(:create, Training) }

      context 'when training is in future' do
        context 'when training belongs to other user' do
          it { is_expected.not_to be_able_to(:manage, other_user_training) }
          it { is_expected.not_to be_able_to(:update, other_user_ut) }
        end

        context 'when training belongs to him' do
          it { is_expected.to be_able_to(:manage, owned_training) }
          it { is_expected.to be_able_to(:update, owned_ut) }
        end

        context 'when users_training belongs to other user' do
          it do
            is_expected.not_to be_able_to(:reaction_to_invite, other_user_ut)
          end
        end

        context 'when only users_training belongs to him' do
          before(:each) do
            other_user_training.users << user
            @invitation = other_user_training.users_trainings.last
          end

          it { is_expected.to be_able_to(:update, @invitation) }

          context 'when invitation is accepted' do
            before(:each) do
              @invitation.update(accepted_at: DateTime.current)
            end

            it do
              is_expected.not_to be_able_to(:reaction_to_invite, @invitation)
            end
          end

          context 'when invitation is not accepted' do
            it { is_expected.to be_able_to(:reaction_to_invite, @invitation) }
          end
        end
      end

      context 'when training is done' do
        before(:each) do
          owned_ut
          Timecop.travel(other_user_training.date + 1.day)
        end

        after(:each) do
          Timecop.return
        end

        context 'when training belongs to him' do
          it { is_expected.to be_able_to(:update, owned_ut) }
        end

        context 'when users_training belongs to him' do
          before(:each) do
            Timecop.travel(other_user_training.date - 1.day)
            other_user_training.users << user
            @invitation = other_user_training.users_trainings.last
            Timecop.travel(other_user_training.date + 1.day)
          end

          after(:each) do
            Timecop.return
          end

          it { is_expected.not_to be_able_to(:update, @invitation.training) }
          it { is_expected.not_to be_able_to(:update, @invitation) }
          it { is_expected.not_to be_able_to(:reaction_to_invite, @invitation) }
        end
      end
    end
  end
end
