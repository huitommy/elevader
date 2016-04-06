Admin.create(
  username: 'admin',
  email: 'admin@admin.com',
  password: 'password'
)

user = User.create(
  username: 'user',
  email: 'user@user.com',
  password: 'password'
)

elevator = Elevator.create(
  building_name: 'Some Building',
  city: 'Some City',
  address: '666 Street of the Beast',
  zipcode: '12345',
  state: 'AK',
  user: user
)

Review.create(
  user: user,
  elevator: elevator,
  rating: 0,
  body: 'Elevator smells awful!'
)
