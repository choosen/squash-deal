require 'rails_helper'

describe Training, type: :model do
  let(:training) { create(:training) }
  subject { training }

  it 'is invalid without a date' do
    training.date = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid with negative price' do
    training.price = -20.50
    expect(subject).not_to be_valid
  end

  it 'is valid with no price' do
    training.price = nil
    expect(subject).to be_valid
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
        let(:training) { create(:training_with_users) }
        subject { training.price_per_user }

        it 'has 2 users' do
          expect(training.users.count).to eq 2
        end

        it 'has 2 users' do
          expect(training.users_trainings.count).to eq 2
        end

        it 'devides price by 2' do
          expect(subject).to eq training.price / 2
        end
      end
    end
  end
end
