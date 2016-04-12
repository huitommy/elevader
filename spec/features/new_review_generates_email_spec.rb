require 'rails_helper'

feature "User edits an existing elevator" do
  scenario "review a product" do
    ActionMailer::Base.deliveries.clear

    tooth = FactoryGirl.create(:user,
                               username: 't00thless',
                               email: 'noteeth@email.com',
                               password: 'password')
    elevator = FactoryGirl.create(:elevator, user: tooth)

    visit new_user_session_path
    fill_in 'Email', with: 'noteeth@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    visit elevator_path(elevator)

    fill_in "Body", with: "Total garbage."
    click_button "Create Review"

    expect(page).to have_content("Total garbage.")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
