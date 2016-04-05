require 'rails_helper'

feature "User edits an existing elevator" do

  scenario "User deletes existing elevator" do

    elevader = Elevator.create(building_name: "test", address: "testing", city: "tester", zipcode: "01234", state: "ma")

    visit '/elevators'
    click_link "test"

    click_link "Delete"

    expect(page).to_not have_content("test")
  end
end
