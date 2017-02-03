require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe UserMailer, type: :mailer do
  let(:training) { create(:training_with_user) }
  let(:user_t) { training.users_trainings.first }

  describe '#training_invitation and ActiveJob mailers queue' do
    subject { UserMailer.training_invitation(user_t).deliver_later }

    it 'creates a job' do
      ActiveJob::Base.queue_adapter = :test
      expect { subject }.to have_enqueued_job.on_queue('mailers')
    end

    it 'sends email' do
      expect { perform_enqueued_jobs { subject } }.
        to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'renders the headers' do
      perform_enqueued_jobs { subject }

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to.first).to eq user_t.user.email
      expect(mail.from.first).to eq UserMailer.default[:from]
      expect(mail.subject).to eq 'Squash training invitation'
    end

    it 'renders the body' do
      perform_enqueued_jobs { subject }

      mail = ActionMailer::Base.deliveries.last
      expect(mail.body.encoded).to match("Hello #{user_t.user.display_name}")
      expect(mail.body.encoded).
        to match('You are invited to take a part in squash training at')
      expect(mail.body.encoded).to match('Confirm play')
      expect(mail.body.encoded).to match('Dismiss invitation')
    end
  end

  describe '#payment_reminder' do
    subject(:mail) { UserMailer.payment_reminder(user_t, training) }

    it 'renders the headers' do
      expect(mail.to.first).to eq user_t.user.email
      expect(mail.from.first).to eq UserMailer.default[:from]
      expect(mail.subject).to eq 'Squash training payment reminder'
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{user_t.user.display_name}")
      expect(mail.body.encoded).
        to match("You played squash training at #{I18n.l training.date}")
      expect(mail.body.encoded).to match('Cost of training is')
    end
  end

  describe '#training_reminder' do
    subject(:mail) { UserMailer.training_reminder(user_t) }

    it 'renders the headers' do
      expect(mail.to.first).to eq user_t.user.email
      expect(mail.from.first).to eq UserMailer.default[:from]
      t_at = training.date.strftime('%H:%M')
      expect(mail.subject).to eq "Your Squash training is tomorrow at #{t_at}"
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hello #{user_t.user.display_name}")
      expect(mail.body.encoded).
        to match('You accepted invitation to squash training at')
      expect(mail.body.encoded).to match("Don't be late!")
    end
  end
end
