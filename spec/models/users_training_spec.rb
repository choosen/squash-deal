require 'rails_helper'

RSpec.describe UsersTraining, type: :model do
  let(:today) { Time.zone.today }
  let(:users_training) { build(:users_training) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :training }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :training }

  subject { users_training }

  describe 'on before_save #set_multisport_used' do
    context "when user don't have got multisport" do
      it 'sets multisport_used to false' do
        subject.save
        expect(subject.reload.multisport_used).to eq false
      end
    end

    context 'when user has multisport' do
      let(:users_training) do
        build(:users_training, user: create(:user_with_multi))
      end

      it 'sets multisport_used to true' do
        subject.save
        expect(subject.reload.multisport_used).to eq true
      end
    end
  end

  describe '#accepted' do
    subject { users_training.accepted? }
    context 'when accepted_at is present' do
      let(:users_training) { build(:users_training, accepted_at: today) }

      it { is_expected.to eq true }
    end

    context 'when accepted_at is blank' do
      it { is_expected.to eq false }
    end
  end

  describe '#user_price' do
    subject { users_training.user_price }

    context 'when user did not attended in training' do
      it { is_expected.to eq 0 }
    end

    context 'when user attended in training' do
      let(:users_training) do
        create(:users_training, user: create(:user_with_multi), attended: true)
      end

      subject { users_training.user_price }

      context 'and user used multisport' do
        it { is_expected.to eq users_training.training.price_per_user - 15 }
      end

      context "and user haven't got multisport" do
        let(:users_training) { create(:users_training, attended: true) }

        it { is_expected.to eq users_training.training.price_per_user }
        it { is_expected.to be_positive }
      end
    end
  end

  describe 'custom validations:' do
    describe 'change of accepted_at' do
      context 'when accepted_at is set' do
        let(:users_training) { create(:users_training, accepted_at: today) }

        it 'is not valid' do
          expect { subject.accepted_at += 1.day }.to change { subject.valid? }.
            from(true).to false
        end
      end

      context 'when accepted_at is nil' do
        it 'is valid' do
          expect { subject.accepted_at = today }.
            not_to change { subject.valid? }
        end
      end
    end

    describe 'set accepted_at' do
      context 'when training end date is in the past' do
        it 'is not valid' do
          expect { subject.training.date = today - 1.month }.
            to change { subject.valid? }.from(true).to false
        end
      end

      context 'when training end date is in the future' do
        it { is_expected.to be_valid }
      end
    end

    describe 'Invite user to training' do
      context 'when training is in the future' do
        it { is_expected.to be_valid }
      end

      context 'when training is in the past' do
        it 'is not valid' do
          expect { subject.training.date = today - 1.month }.
            to change { subject.valid? }.from(true).to(false)
        end
      end
    end
  end
end
