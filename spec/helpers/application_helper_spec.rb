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

  describe '#bottom_closed_on_focus_popover' do
    let(:title) { 'Pending invitation' }
    let(:text) do
      'Training owner sent you an email invitation, which you didn\'t ' \
      'accepted. You can click at training on calendar to accept it or ' \
      'follow the link in email.'
    end

    subject { helper.bottom_closed_on_focus_popover(title, text) }

    it 'return well formated attributes for popover' do
      {
        href: '#', 'data-trigger' => 'focus', 'data-placement' => 'bottom',
        title: title, 'data-content' => text
      }
    end
  end
end
