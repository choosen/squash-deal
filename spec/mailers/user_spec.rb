require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe UserMailer, type: :mailer do
  let(:training) { create(:training_with_user) }
  let(:user_t) { training.users_trainings.first }

  describe '#training_invitation' do
    subject { UserMailer.training_invitation(user_t).deliver_later }

    it 'creates a job' do
      ActiveJob::Base.queue_adapter = :test
      expect { subject }.to have_enqueued_job.on_queue('mailers')
    end

    it 'sends email' do
      expect { perform_enqueued_jobs { subject } }.
        to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends email to right user' do
      perform_enqueued_jobs { subject }

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq training.users.first.email
    end
  end
end
