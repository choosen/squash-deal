require 'rails_helper'

RSpec.describe Training, type: :model do
  let(:training) { create(:training) }
  subject { training }

  it { is_expected.to have_many :users }
  it { is_expected.to have_many :users_trainings }

  it { is_expected.to validate_presence_of :date }

  it do
    is_expected.to validate_numericality_of(:price).is_greater_than(0.0).
      allow_nil
  end

  describe '#price_per_user' do
    context 'when there are no users_trainings' do
      let(:training) { create(:training) }
      subject { training.price_per_user }
      it 'returns 0 if there are no users in training' do
        expect(subject).to eq 0
      end
    end

    context 'when there are 3 users_trainings' do
      context 'when 2 of them attended' do
        before(:each) do
          @training = create(:training_with_users)
          @training.users_trainings.
            first(2).each { |ut| ut.update(attended: true) }
        end

        subject { @training.price_per_user }

        it 'devides price by 2' do
          expect(subject).to eq training.price / 2
        end
      end
    end
  end
end
