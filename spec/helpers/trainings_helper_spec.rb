require 'rails_helper'

RSpec.describe TrainingsHelper, type: :helper do
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

      it { is_expected.to eq I18n.l(DateTime.current, format: :datetimepicker) }
    end

    context 'when date is filled' do
      let(:training) { create(:training) }

      subject { helper.format_picker_date(training) }

      it { is_expected.to eq I18n.l(training.date, format: :datetimepicker) }
    end
  end
end
