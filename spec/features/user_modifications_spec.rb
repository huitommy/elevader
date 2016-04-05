require 'rails_helper'

feature 'User can edit and delete account' do

  before :each do
    FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
    visit '/users/sign_in'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end

  scenario 'user can access page to edit profile' do
    click_on 'Profile'
    expect(page).to have_content('Password')
    expect(page).to have_content('Password confirmation')
    expect(page).to have_content('Current password')
  end

  scenario 'user can change email from edit profile page' do
    click_on 'Profile'
    fill_in 'Email', with: 'new@email.com'
    fill_in 'Current password', with: 'password'
    click_on 'Update'

    expect(page).to have_content('Your account has been updated successfully.')

    click_on 'Sign Out'
    click_on 'Sign In'
    fill_in 'Email', with: 'new@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user can change password from edit profile page' do
    click_on 'Profile'
    fill_in 'Password', with: 'newpassword'
    fill_in 'Password confirmation', with: 'newpassword'
    fill_in 'Current password', with: 'password'
    click_on 'Update'

    expect(page).to have_content('Your account has been updated successfully.')

    click_on 'Sign Out'
    click_on 'Sign In'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'newpassword'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user can delete profile in edit profile page' do
    click_on 'Profile'
    click_on 'Cancel my account'
    expect(page).to have_content('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
    expect(page).to_not have_content('Sign Out')

    click_on 'Sign In'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    expect(page).to have_content('Invalid email or password.')
  end
  
end
