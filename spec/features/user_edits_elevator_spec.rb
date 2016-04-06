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

  scenario "User visits page with existing elevator and clicks edit link, fields should be populated with existing data" do

    elevader

    visit elevators_path
    click_link "test"

    click_link "Edit Elevator"

    expect(page).to have_content("Edit")
    expect(page).to have_content("test")
    expect(page).to have_selector("input[value='tester']")
    expect(page).to have_selector("input[value='ma']")
    expect(page).to have_selector("input[value ='01234']")
  end

  scenario "User sucessfully edits an existing elevator profile" do

    elevader

    visit elevators_path
    click_link "test"

    click_link "Edit Elevator"

    fill_in 'Address', with: 'test street'
    fill_in 'City', with: 'teston'
    fill_in 'Zipcode', with: '02142'
    fill_in 'State', with: 'ta'

    click_on "Update Elevator"

    expect(page).to have_content("test")
    expect(page).to have_content("test street")
    expect(page).to have_content("02142")
    expect(page).to have_content("ta")
  end
end
