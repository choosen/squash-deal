require 'rails_helper'

RSpec.describe TrainingsHelper, type: :helper do
  describe '#formatted_ut_accepted_at' do
    let(:ut) { build(:users_training) }

    subject { helper.formatted_ut_accepted_at(ut) }

    context 'when accepted_at is given' do
      let(:ut) { build(:users_training, accepted_at: DateTime.current) }

      it { is_expected.to eq l ut.accepted_at, format: :short }
    end

    context 'when accepted_at is nil' do
      it { is_expected.to eq '' }
    end
  end

  describe '#format_picker_date' do
    context 'when date is nil' do
      before(:each) do
        Timecop.freeze
      end

      after(:each) do
        Timecop.return
      end

      let(:training) { build(:training, date: nil) }

      subject { helper.format_picker_date(training) }

      it { is_expected.to eq I18n.l(DateTime.current, format: :default) }
    end

    context 'when date is filled' do
      let(:training) { create(:training) }

      subject { helper.format_picker_date(training) }

      it { is_expected.to eq I18n.l(training.date, format: :default) }
    end
  end
end
