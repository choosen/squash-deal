require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_date_if_present' do
    let(:date) { DateTime.current }

    subject { helper.format_date_if_present(date) }

    context 'when date is given' do
      it { is_expected.to eq l date, format: :default }
    end

    context 'when date is nil' do
      subject { helper.format_date_if_present(nil) }

      it { is_expected.to eq '' }
    end
  end
end
