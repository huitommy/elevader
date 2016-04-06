require 'rails_helper'

feature 'Admin authentication:' do

  before :each do
    FactoryGirl.create(:admin, email: 'admin@admin.com')
    FactoryGirl.create(:user, email: 'user@user.com')
    visit '/admins/sign_in'
  end

  scenario 'admin has a sign-in page' do
    expect(page).to have_css('input#admin_email')
    expect(page).to have_css('input#admin_password')
    expect(page).to have_content('Log in')
  end

  scenario 'admin can sign-in' do
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
    expect(page).to_not have_content('Sign In')
  end

  scenario 'admin can sign-out' do
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    click_on 'Sign Out'

    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_content('Sign In')
  end

  scenario 'user cannot sign-in as admin' do
    fill_in 'Email', with: 'user@user.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    expect(page).to_not have_content('You are not admin')
    expect(page).to have_content('Sign In')
  end
  
end