require 'rails_helper'

feature 'User accounts:' do

  scenario 'user can create an account' do
    visit '/'
    click_link 'Sign Up!'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'user does not submit an email'  do
    visit '/'
    click_link 'Sign Up!'
    fill_in 'Password', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

end
