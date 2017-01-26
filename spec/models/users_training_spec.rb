require 'rails_helper'

RSpec.describe UsersTraining, type: :model do
  let(:today) { Time.zone.today }
  let(:users_training) { build(:users_training) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :training }

  subject { users_training }

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
        it 'is valid' do
          expect(subject.valid?).to eq true
        end
      end
    end

    describe 'Invite user to training' do
      context 'when training is in the future' do
        it 'is valid' do
          expect(subject.valid?).to eq true
        end
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
