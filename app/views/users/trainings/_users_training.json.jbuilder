json.extract! users_training.training, :id
json.title "Players: #{users_training.training.users.size}"
json.start users_training.training.date
json.end users_training.training.date + 1.hour
if users_training.accepted?
  json.color 'Green'
  json.url training_url(users_training.training, format: :html)
elsif users_training.training.done?
  json.color 'Red'
  json.url training_url(users_training.training, format: :html)
else
  json.color 'DarkSalmon'
  if current_user.id == users_training.user_id && !users_training.training.done?
    json.url invitation_accept_training_url(users_training.training,
                                            format: :html)
  else
    json.url training_url(users_training.training, format: :html)
  end
end
