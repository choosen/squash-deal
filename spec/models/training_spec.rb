require 'rails_helper'

RSpec.describe Training, type: :model do
  let(:training) { build(:training) }
  let!(:dt_now) { DateTime.current }
  subject { training }

  it { is_expected.to have_many :users }
  it { is_expected.to have_many :users_trainings }
  it { is_expected.to belong_to :owner }

  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :owner }

  it do
    is_expected.to validate_numericality_of(:price).is_greater_than(0.0).
      allow_nil
  end

  describe 'scope date_between' do
    before(:each) do
      @scope_trainings_table = [create(:training, date: dt_now + 2.hours),
                                create(:training, date: dt_now + 4.hours)]
      @out_of_range_training =  create(:training, date: dt_now + 5.days)
    end

    subject { Training.date_between(dt_now, dt_now + 1.day) }

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
          @training.users_trainings.last.update(attended: false)
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

  describe 'custom validation:' do
    describe '#date_cannot_be_change_to_the_past' do
      context 'when date is set in the future' do
        it { is_expected.to be_valid }
      end

      context 'when date is set in the past' do
        context 'when we change date' do
          it 'validates false' do
            expect { subject.date = dt_now - 1.day }.
              to change { subject.valid? }.from(true).to(false)
          end
        end
      end

      context 'when date was set in the past' do
        context 'when we change price' do
          it 'validates as true' do
            expect { subject.price += 1 }.not_to change { subject.valid? }
          end
        end
      end
    end

    describe '#finished_cannot_be_changed' do
      context 'when we change price' do
        context 'when training is finished' do
          let(:training) { create(:training, finished: true) }

          it { is_expected.to be_invalid }
        end

        context 'when training is open' do
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
