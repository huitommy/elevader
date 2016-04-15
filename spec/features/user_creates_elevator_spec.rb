require 'rails_helper'

feature 'User creates new elevator' do

  context "user is signed in" do
    before(:each) do
      FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
      visit new_user_session_path
      fill_in 'Email', with: 'noteeth@email.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      binding.pry
    end

    scenario 'User visits page with new elevator form and fills it out correctly' do
      click_link 'Add Elevator'
      fill_in 'Building name', with: 'test'
      fill_in 'Address', with: 'test street'
      fill_in 'City', with: 'teston'
      fill_in 'Zipcode', with: '02142'
      fill_in 'State', with: 'ta'
      attach_file :elevator_elevator, "#{Rails.root}/spec/fixtures/images/sampleprofile.jpg"
      click_on 'Create Elevator'

      expect(page).to have_content('You have successfully added an elevader!')
      expect(page).to have_css("img[src*='sampleprofile.jpg']")
      expect(page).to have_content('test')
    end

    scenario 'User visits page with new elevader form and fills out incorrectly' do
      click_link 'Add Elevator'
      fill_in 'Address', with: 'test street'
      fill_in 'City', with: 'teston'
      fill_in 'Zipcode', with: '02142'
      fill_in 'State', with: 'ta'
      click_on 'Create Elevator'

      expect(page).to have_content("Building name can't be blank")
      expect(page).to_not have_content('test')
      expect(page).to have_selector("input[value='test street']")
      expect(page).to have_selector("input[value='ta']")
      expect(page).to have_selector("input[value ='02142']")
    end
  end

  scenario 'User is not logged in and tries to submit a new elevator form' do
    visit elevators_path
    click_link 'Add Elevator'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
