json.extract! user_training.training, :id
json.start user_training.training.date
json.end user_training.training.date + 1.hour
if user_training.accepted?
  json.color 'Green'
  json.url training_url(user_training.training, format: :html)
else
  json.color 'DarkSalmon'
  json.url training_invitation_accept_url(user_training.training, format: :html)
end
