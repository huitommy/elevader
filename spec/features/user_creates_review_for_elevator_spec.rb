require 'rails_helper'

feature 'User inputs review' do
  scenario 'User visits page with existing elevator and adds review data while signed in' do
    FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
    visit '/users/sign_in'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    FactoryGirl.create(:elevator, building_name: 'test')
    visit elevators_path
    click_link 'test'

    select '3', from: 'Rating'
    fill_in 'Body', with: 'Testing testers with test data.'

    click_on 'Create Review'

    expect(page).to have_content('Rating: 3')
    expect(page).to have_content('test')
    expect(page).to have_content('Testing testers with test data.')
  end

  scenario 'User visits page with existing elevator and is unable to submit review while signed out' do
    FactoryGirl.create(:elevator, building_name: 'test')
    visit elevators_path
    click_link 'test'

    select '3', from: 'Rating'
    fill_in 'Body', with: 'Testing testers with test data.'

    click_on 'Create Review'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to_not have_content('Testing testers with test data.')
    expect(page).to_not have_content('Review Added!')
  end
end
