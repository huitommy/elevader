require 'rails_helper'

feature 'User edits an existing elevator' do
  scenario 'User deletes existing elevator' do
    a = FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
    FactoryGirl.create(:elevator, building_name: 'test', user: a)

    visit '/users/sign_in'
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    visit elevators_path
    click_link 'test'
    click_link 'Delete'

    expect(page).to_not have_content('test')
  end

  scenario 'User does not see Delete button' do
    FactoryGirl.create(:elevator, building_name: 'test')
    visit elevators_path
    click_link 'test'

    expect(page).to_not have_content('Delete')
  end

  context "user is signs in" do
    before(:each) do
      FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
      visit '/users/sign_in'
      fill_in 'Email', with: 'noteeth@email.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
    end

    scenario 'User is unable to delete elevator if they were not the one who created it' do
      click_link 'Add Elevator'
      fill_in 'Building name', with: 'test'
      fill_in 'Address', with: 'test street'
      fill_in 'City', with: 'teston'
      fill_in 'Zipcode', with: '02142'
      fill_in 'State', with: 'ta'
      click_on 'Create Elevator'
      click_link 'Sign Out'

      FactoryGirl.create(:user, username: 't00thless1', email: '1noteeth@email.com', password: 'password1')
      visit '/users/sign_in'
      fill_in 'Email', with: '1noteeth@email.com'
      fill_in 'Password', with: 'password1'
      click_on 'Log in'
      click_link 'test'

      expect(page).to_not have_content('Delete')
    end
  end
end
