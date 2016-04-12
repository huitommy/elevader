require 'rails_helper'

feature 'Admin can view user pagination' do

  before :each do
    FactoryGirl.create(:admin)
    visit new_admin_session_path
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    30.times { FactoryGirl.create(:user) }
    visit users_path
  end

  scenario 'User sees multiple pages of elevators' do
    expect(page).to have_link('Next ›')
    expect(page).to have_link('Last »')
  end
end
