Admin.create(
  username: 'admin',
  email: 'admin@admin.com',
  password: 'password'
)

users = []
(1..20).each do |i|
  users << User.create(
    username: "User ##{i}",
    email: "user#{i}@user.com",
    password: 'password'
  )
end

elevators = []
(1..10).each do |i|
  elevators << Elevator.create(
    building_name: "Building ##{i}",
    city: 'Some City',
    address: '666 Street of the Beast',
    zipcode: '12345',
    state: 'AK',
    user: users.sample
  )
end

(1..100).each do
  Review.create(
    user: users.sample,
    elevator: elevators.sample,
    rating: (0..5).to_a.sample,
    body: 'Elevator smells awful!'
  )
end
