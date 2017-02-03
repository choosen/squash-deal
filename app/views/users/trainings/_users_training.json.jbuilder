json.extract! users_training.training, :id
json.start users_training.training.date
json.end users_training.training.date + 1.hour
if users_training.accepted?
  json.color 'Green'
  json.url training_url(users_training.training, format: :html)
else
  json.color 'DarkSalmon'
  json.url training_invitation_accept_url(users_training.training,
                                          format: :html)
end
