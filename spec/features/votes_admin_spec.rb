require 'rails_helper'

feature 'Voting buttons:' do

  before :each do
    FactoryGirl.create(:admin, email: 'admin@admin.com')
    @elevator = FactoryGirl.create(:elevator, building_name: 'Mission Control')
    6.times do
      FactoryGirl.create(
        :review,
        elevator: @elevator
      )
    end

    visit new_admin_session_path
    fill_in 'Email', with: 'admin@admin.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    click_on 'splash_screen'
    click_on 'Mission Control'
  end

  scenario 'Admin can see voting buttons and vote total' do
    expect(page).to have_css('#upvote', count: 6)
    expect(page).to have_css('#downvote', count: 6)
    expect(page).to have_css('.vote-total', count: 6)
  end

  scenario 'Admin cannot upvote' do
    review = Review.third
    within(:css, "#review-#{review.id}") do
      click_on 'upvote'
    end
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'Admin cannot downvote' do
    review = Review.fourth
    within(:css, "#review-#{review.id}") do
      click_on 'downvote'
    end
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

end
