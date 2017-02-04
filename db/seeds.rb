User.create_without_invite(email: 'admin@sample.com',
                                   password: '12345678', admin: true)

player = User.create_without_invite(email: 'player@sample.com',
                                    password: '12345678')

training = Training.create(date: DateTime.now, price: 120.00)
training.users << player
