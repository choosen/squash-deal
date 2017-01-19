desc 'Task is called by HEroku scheduler add-on'
task send_reminders: :environment do
  trainings = Training.where('DATE(created_at) = ?', Date.tomorrow)
  trainings.each do |training|
    training.users_trainings.each do |users_training|
      if users_training.accepted?
        UserMailer.training_reminder(users_training).deliver_later
      end
    end
  end
end
