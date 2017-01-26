require 'rails_helper'

RSpec.describe Training, type: :model do
  let(:training) { build(:training) }
  subject { training }

  it { is_expected.to have_many :users }
  it { is_expected.to have_many :users_trainings }

  it { is_expected.to validate_presence_of :date }

  it do
    is_expected.to validate_numericality_of(:price).is_greater_than(0.0).
      allow_nil
  end

  describe 'scope date_between' do
    before(:each) do
      @begin_d = DateTime.new(2016, 1, 25, 16, 45).utc
      @scope_trainings_table = [create(:training, date: @begin_d + 2.hours),
                                create(:training, date: @begin_d + 4.hours)]
      @out_of_range_training =  create(:training, date: @begin_d - 5.hours)
    end

    subject { Training.date_between(@begin_d, @begin_d + 1.day) }

    it 'returns only trainings between the date' do
      expect(subject).to eq @scope_trainings_table
    end

    it 'returns no training with date out of range' do
      expect(subject).not_to include @out_of_range_training
    end
  end

  describe '#price_per_user' do
    context 'when there are no users_trainings' do
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

  describe '#done?' do
    subject { training.done? }

    context 'when date is in future' do
      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'when date is in past' do
      let(:training) { build(:training, date: DateTime.current - 2.days) }

      it 'returns true' do
        expect(subject).to eq true
      end
    end
  end
end
