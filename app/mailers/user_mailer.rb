# Mailer for registred users
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def training_invitation(users_training)
    @user = users_training.user
    @training = users_training.training
    @decline_url = training_invitation_remove_url(@training)
    @accept_url = training_invitation_accept_url(@training)
    mail(to: @user.email, subject: 'Squash training invitation')
  end

  def payment_reminder(users_training, training)
    @user = users_training.user
    @training = training
    @training_user_price = training.price_per_user
    @training_user_price -= 15 if users_training.multisport_used?
    mail(to: @user.email, subject: 'Squash training payment reminder')
  end

  def training_reminder(users_training)
    @user = users_training.user
    @training = users_training.training
    mail(to: @user.email, subject: 'Your Squash training is tomorrow')
  end
end
