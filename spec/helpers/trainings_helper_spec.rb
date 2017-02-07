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
end
