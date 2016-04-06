require 'rails_helper'

feature "User edits an existing elevator" do
  let!(:elevader) do
    Elevator.create(
      building_name: "test",
      address: "testing",
      city: "tester",
      zipcode: "01234",
      state: "ma"
    )
  end

  scenario "User deletes existing elevator" do
    elevader

    visit elevators_path
    click_link "test"

    click_link "Delete"

    expect(page).to_not have_content("test")
  end
end
