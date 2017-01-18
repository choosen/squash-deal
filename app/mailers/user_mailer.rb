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
end
