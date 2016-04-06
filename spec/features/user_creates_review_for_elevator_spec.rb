require 'rails_helper'

feature "User inputs review" do

  let!(:elevader) do
    Elevator.create(
      building_name: "test",
      address: "testing",
      city: "tester",
      zipcode: "01234",
      state: "ma"
    )
  end

  scenario "User visits page with existing elevator and adds review data" do

    elevader

    visit elevators_path
    click_link "test"

    select '3', from: 'Rating'
    fill_in 'Body', with: "Testing testers with test data. Testicles."

    click_on "Create Review"

    expect(page).to have_content("Rating: 3")
    expect(page).to have_content("test")
    expect(page).to have_content("Testing testers with test data. Testicles.")
  end
end
