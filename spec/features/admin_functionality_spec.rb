require 'rails_helper'

feature 'Admin functionality:' do

  before :each do
    FactoryGirl.create(:admin, email: 'admin@admin.com')
    2.times { FactoryGirl.create(:admin) }
    5.times { FactoryGirl.create(:elevator) }
    visit new_admin_session_path
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end

  scenario 'admin can see list of users' do
    visit users_path
    expect(page).to have_css('.user', count: 5)
  end

  scenario 'admin can erase users from list of users' do
    visit users_path
    user = User.third
    within(:css, "#user-#{user.id}") do
      click_on 'Delete'
    end
    expect(page).to have_content('User was deleted')
    expect(page).to have_css('.user', count: 4)

    visit users_path
    expect(page).to have_css('.user', count: 4)
  end

  scenario 'admin can see list of elevators' do
    visit elevators_path
    expect(page).to have_css('.card', count: 5)
  end

  scenario 'admin can erase an elevator from the elevator show page' do
    elevator = Elevator.third
    visit elevator_path(elevator)
    click_on 'Delete'

    expect(page).to have_content('Elevator was deleted')
    expect(page).to have_css('.card', count: 4)
  end

  scenario 'admin can see reviews in elevator show page' do
    elevator = Elevator.first
    3.times { FactoryGirl.create(:review, elevator: elevator) }
    visit "/elevators/#{elevator.id}"

    expect(page).to have_css('.card', count: 3)
  end

  scenario 'admin can erase reviews from elevator show page' do
    elevator = Elevator.first
    3.times { FactoryGirl.create(:review, elevator: elevator) }
    review = Review.second
    visit "/elevators/#{elevator.id}"
    within(:css, "#review-#{review.id}") do
      click_on 'Delete'
    end

    expect(page).to have_content('Review was deleted')
    expect(page).to have_css('.card', count: 2)
  end

  scenario 'admin can view list of admins' do
    click_on 'Admins'

    expect(page).to have_css('.admin', count: 3)
  end

  scenario 'admin can make an existing user admin' do
    click_on 'Admins'
    click_on 'Add New Admin'
    user = User.fourth
    within(:css, "#user-#{user.id}") do
      click_on 'Make Admin'
    end

    expect(page).to have_content("#{user.username} is now an admin")
    expect(page).to have_css('.admin', count: 4)
  end

  scenario 'admin can erase other admins from list of admins' do
    click_on 'Admins'
    admin = Admin.third
    within(:css, "#admin-#{admin.id}") do
      click_on 'Delete'
    end

    expect(page).to have_content('Admin was deleted')
    expect(page).to have_css('.admin', count: 2)
  end

end
