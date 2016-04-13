require 'rails_helper'

feature 'User edits an existing review' do
  before(:each) do
    a = FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
    FactoryGirl.create(:elevator, building_name: 'test', user: a)
    visit new_user_session_path
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    visit elevators_path
    click_link 'test'
    fill_in 'Body', with: 'sample body'
    select '3', from: 'Rating'
    click_on 'Create Review'
  end

  scenario 'User edits existing review' do
    expect(page).to have_content('sample body')
    click_on 'Edit Review'
    fill_in 'Body', with: 'derp'
    click_on 'Update Review'

    expect(page).to_not have_content('sample body')
    expect(page).to have_content('derp')
  end

  scenario 'User is unable to edit existing review if they are not logged in' do
    expect(page).to have_content('sample body')
    click_link 'Sign Out'
    click_link 'test'
    within(:css, '.review_buttons') do
      expect(page).not_to have_content("Edit")
    end
  end

  scenario 'User is unable to edit review if they were not the one who created it' do
    expect(page).to have_content('sample body')
    click_link 'Sign Out'
    FactoryGirl.create(:user, username: 't00thless1', email: '1noteeth@email.com', password: 'password1')
    visit new_user_session_path
    fill_in 'Email', with: '1noteeth@email.com'
    fill_in 'Password', with: 'password1'
    click_on 'Log in'
    click_link 'test'
    elevator = Elevator.first
    review = elevator.reviews.first
    within(:css, "#review-#{review.id}") do
      expect(page).not_to have_content("Edit")
    end
    expect(page).to have_content('sample body')
  end
end
