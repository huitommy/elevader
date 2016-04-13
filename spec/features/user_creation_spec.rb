require 'rails_helper'

feature 'User Creation:' do

  before :each do
    visit root_path
    click_link 'Sign Up'
  end

  scenario 'user can create an account' do
    fill_in 'Username', with: 't00thless'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    attach_file :user_avatar, "#{Rails.root}/spec/fixtures/images/sampleprofile.jpg"
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')

    click_link 'Profile'
    expect(page).to have_css("img[src*='sampleprofile.jpg']")
  end

  scenario 'user attempts to use an username that already exists' do
    FactoryGirl.create(:user, username: 't00thless')

    fill_in 'Username', with: 't00thless'
    fill_in 'Email', with: 'anothertestemail@test.test'
    fill_in 'Password', with: 'anotherpassword'
    fill_in 'Password confirmation', with: 'anotherpassword'
    click_on 'Sign up'

    expect(page).to have_content('Username has already been taken')
  end

  scenario 'user attempts to use an username that already exists' do
    FactoryGirl.create(:user, email: 'email@example.com')

    fill_in 'Username', with: 't00thless'
    fill_in 'Email', with: 'email@example.com'
    fill_in 'Password', with: 'anotherpassword'
    fill_in 'Password confirmation', with: 'anotherpassword'
    click_on 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end

  scenario 'user does not submit an email' do
    fill_in 'Username', with: 't00thless'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
  end

  scenario 'user does not submit username' do
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content("Username can't be blank")
  end

  scenario 'user does not add password confirmation' do
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'user password and confirmation do not match' do
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'pasword'
    click_on 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

end
