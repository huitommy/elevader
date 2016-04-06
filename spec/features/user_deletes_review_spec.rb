require 'rails_helper'

feature 'User deletes an existing review' do
  before(:each) do
    a = FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
    FactoryGirl.create(:elevator, building_name: 'test', user: a)

    visit '/users/sign_in'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    visit elevators_path
    click_link 'test'
    fill_in 'Body', with: 'sample body'
    select '3', from: 'Rating'
    click_on 'Create Review'
  end
  
  scenario 'User deletes existing review' do
    expect(page).to have_content('sample body')
    click_on 'Delete Review'
    expect(page).to_not have_content('sample body')
  end

  scenario 'User is unable to delete existing review if they are not logged in' do
    expect(page).to have_content('sample body')
    click_link 'Sign Out'
    click_link 'test'
    click_on 'Delete Review'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_content('Log in')
  end

  scenario 'User is unable to delete review if they were not the one who created it' do
    expect(page).to have_content('sample body')
    click_link 'Sign Out'

    FactoryGirl.create(:user, username: 't00thless1', email: '1noteeth@email.com', password: 'password1')
    visit '/users/sign_in'
    fill_in 'Email', with: '1noteeth@email.com'
    fill_in 'Password', with: 'password1'
    click_on 'Log in'
    click_link 'test'
    click_on 'Delete Review'

    expect(page).to have_content('You do not have permission to change review')
    expect(page).to have_content('sample body')
  end
end
