# Mailer for registred users
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def training_invitation(users_training)
    @user = users_training.user
    training = users_training.training
    @decline_url = training_invitation_remove_url(training)
    @accept_url = training_invitation_accept_url(training)
    @training_date = I18n.l training.date
    mail(to: @user.email, subject: 'Squash training invitation')
  end

  def payment_reminder(users_training, training)
    @user = users_training.user
    @training_date = I18n.l training.date
    @training_user_price = users_training.user_price
    mail(to: @user.email, subject: 'Squash training payment reminder')
  end

  def training_reminder(users_training)
    @user = users_training.user
    training = users_training.training
    training_at = I18n.l training.date, format: :time
    @training_date = I18n.l training.date
    mail(to: @user.email,
         subject: "Your Squash training is tomorrow at #{training_at}")
  end
end
