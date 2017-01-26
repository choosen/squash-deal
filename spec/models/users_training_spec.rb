require 'rails_helper'

RSpec.describe UsersTraining, type: :model do
  let(:today) { Time.zone.today }
  let(:users_training) { create(:users_training) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :training }

  describe 'custom validations:' do
    describe 'change of accepted_at' do
      subject { users_training }

      context 'when accepted_at is set' do
        let(:users_training) { create(:users_training, accepted_at: today) }

        it 'is not valid' do
          expect { subject.accepted_at += 1.day }.to change { subject.valid? }.
            from(true).to(false)
        end
      end

      context 'when accepted_at is nil' do
        it 'is valid' do
          expect { subject.accepted_at = today }.
            not_to change { subject.valid? }
        end
      end
    end

    describe 'set accepted_at only before training' do
      skip('#TODO')
    end
    describe 'send invitition before training date' do
      skip('#TODO')
    end
  end
end
