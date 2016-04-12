require 'rails_helper'

feature 'Voting buttons for reviews:' do

  before :each do
    @elevator = FactoryGirl.create(:elevator, building_name: 'Mission Control')
    7.times do
      FactoryGirl.create(
        :review,
        elevator: @elevator
      )
    end
    visit '/'
    click_on 'Mission Control'
  end

  scenario 'Logged-out user can see voting buttons and vote total' do
    expect(page).to have_css('#upvote', count: 7)
    expect(page).to have_css('#downvote', count: 7)
    expect(page).to have_css('.vote-total', count: 7)
  end

  scenario 'Logged-out user is prompted to sign-in if she attempts to upvote' do
    review = Review.second
    within(:css, "#review-#{review.id}") do
      click_on 'upvote'
    end
    expect(page).to have_content('You need to sign in or sign up before continuing.')

    visit '/'
    click_on 'Mission Control'
    within(:css, "#review-#{review.id} .vote-total") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('1')
    end
  end

  scenario 'Logged-out user is prompted to sign-in if she attempts to downvote' do
    review = Review.second
    within(:css, "#review-#{review.id}") do
      click_on 'downvote'
    end
    expect(page).to have_content('You need to sign in or sign up before continuing.')

    visit '/'
    click_on 'Mission Control'
    within(:css, "#review-#{review.id} .vote-total") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('-1')
    end
  end

end
