admin = User.create_without_invite(email: 'admin@sample.com',
                                   password: '12345678', admin: true)

fail 'Admin not created' unless admin.persisted?

player = User.create_without_invite(email: 'player@sample.com',
                                    password: '12345678')

fail 'Player not created' unless player.persisted?
training = Training.create!(date: DateTime.now + 1.day, price: 120.00,
                            owner: player)
training.users << player
