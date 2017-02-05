json.extract! users_training.training, :id
json.start users_training.training.date
json.end users_training.training.date + 1.hour
if users_training.accepted?
  json.color 'Green'
  json.url training_url(users_training.training, format: :html)
else
  if users_training.training.done?
    json.color 'Red'
    json.url training_url(users_training.training, format: :html)
  else
    json.color 'DarkSalmon'
    json.url invitation_accept_training_url(users_training.training,
                                            format: :html)
  end
end
