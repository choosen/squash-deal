User.create_without_invite(email: 'admin@sample.com',
                                   password: '12345678', admin: true)

player = User.create_without_invite(email: 'player@sample.com',
                                    password: '12345678')
if player
  training = Training.create!(date: DateTime.now + 1.day, price: 120.00,
                              owner: player)
  training.users << player
end
