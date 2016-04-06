require 'rails_helper'

feature 'Admin functionality:' do

  before :each do
    FactoryGirl.create(:admin, email: 'admin@admin.com')
    2.times { FactoryGirl.create(:admin) }
    5.times { FactoryGirl.create(:elevators) }
    visit '/admins/sign_in'
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end

  scenario 'admin can see list of users' do
    visit '/users'
    expect(page).to have_css('.user', count: 5)
  end

  scenario 'admin can erase users from list of users' do
    visit '/users'
    click_on 'Delete', match: :third
    expect(page).to have_content('User was deleted')
    expect(page).to have_css('.user', count: 4)

    visit '/users'
    expect(page).to have_css('.user', count: 4)
  end

  scenario 'admin can s
  ee list of elevators' do
    visit '/elevators'
    expect(page).to have_css('.elevator', count: 5)
  end

  scenario 'admin can erase elevators from list of elevators' do
    visit '/elevators'
    click_on 'Delete', match: :fifth
    expect(page).to have_content('Elevator was deleted')
    expect(page).to have_css('.elevator', count: 4)

    visit '/elevators'
    expect(page).to have_css('.elevator', count: 4)
  end

  scenario 'admin can erase an elevator from the elevator show page' do
    visit '/elevators'
    click_on '.elevator', match: :second
    click_on 'Delete Elevator'

    expect(page).to have_content('Elevator was deleted')
    expect(page).to have_css('.elevator', count: 4)
  end

  scenario 'admin can see reviews in elevator show page' do
    elevator = Elevator.first
    3.times { FactoryGirl.create(:review, elevator: elevator) }
    visit "/elevators/#{elevator.id}"

    expect(page).to have_css('.review', count: 3)
  end

  scenario 'admin can erase reviews from elevator show page' do
    elevator = Elevator.first
    3.times { FactoryGirl.create(:review, elevator: elevator) }
    visit "/elevators/#{elevator.id}"
    click_on '.review', match: :third

    expect(page).to have_content('Review was deleted')
    expect(page).to have_css('.review', count: 2)
  end

  scenario 'admin can view list of admins' do
    click_on 'Admins'

    expect(page).to have_css('.admin', count: 3)
  end

  scenario 'admin can make an existing users admin' do
    click_on 'Admins'
    click_on 'Add New Admin'
    user = User.fourth
    fill_in 'Email', with: user.email
    click_on 'Add admin'

    expect(page).to have_content("New admin has been added")
    expect(page).to have_css('.admin', count: 4)
  end

  scenario 'admin can erase other admins from list of admins' do
    click_on 'Admins'
    click_on 'Delete', match: :fifth

    expect(page).to have_content('Admin was deleted')
    expect(page).to have_css('.admin', count: 2)
  end
  
end