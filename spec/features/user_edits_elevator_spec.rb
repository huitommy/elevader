require 'rails_helper'

feature "User edits an existing elevator" do

  context "user is signed in" do
    before(:each) do
      tooth = FactoryGirl.create(:user, username: 't00thless', email: 'noteeth@email.com', password: 'password')
      FactoryGirl.create(:elevator, zipcode: "92312", building_name: "testname", state: "teststate", user: tooth)

      visit new_user_session_path
      fill_in 'Email', with: 'noteeth@email.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
    end

    scenario "User visits page with existing elevator and clicks edit link, fields should be populated with existing data" do
      visit elevators_path
      click_link "test"
      click_link "Edit"

      expect(page).to have_content("Edit")
      expect(page).to have_content("test")
      expect(page).to have_selector("input[value='testname']")
      expect(page).to have_selector("input[value='teststate']")
      expect(page).to have_selector("input[value ='92312']")
    end

    scenario "User sucessfully edits an existing elevator profile" do
      visit elevators_path
      click_link "test"
      click_link "Edit"
      fill_in 'Address', with: 'test street'
      fill_in 'City', with: 'teston'
      fill_in 'Zipcode', with: '02142'
      fill_in 'State', with: 'ta'
      attach_file :elevator_elevator, "#{Rails.root}/spec/fixtures/images/sampleprofile.jpg"

      click_on "Update Elevator"

      expect(page).to have_css("img[src*='sampleprofile.jpg']")
      expect(page).to have_content("test")
      expect(page).to have_content("test street")
      expect(page).to have_content("02142")
      expect(page).to have_content("ta")
    end

    scenario "User is unable to delete elevator if they were not the one who created it" do
      click_link 'Add Elevator'
      fill_in 'Building name', with: 'test'
      fill_in 'Address', with: 'test street'
      fill_in 'City', with: 'teston'
      fill_in 'Zipcode', with: '02142'
      fill_in 'State', with: 'ta'
      click_on 'Create Elevator'
      click_link 'Sign Out'

      FactoryGirl.create(:user, username: 't00thless1', email: '1noteeth@email.com', password: 'password1')
      visit new_user_session_path
      fill_in 'Email', with: '1noteeth@email.com'
      fill_in 'Password', with: 'password1'
      click_on 'Log in'
      click_link 'test'
      expect(page).not_to have_content("Edit")
    end
  end

  scenario "User tries to edits an elevator without signing in" do
    FactoryGirl.create(:elevator, building_name: "test")
    visit elevators_path
    click_link "test"

    expect(page).not_to have_content("Edit")
  end
end
