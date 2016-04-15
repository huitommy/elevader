require 'rails_helper'

feature 'Voting buttons for reviews:', js: true do

  before :each do
    5.times { FactoryGirl.create(:user) }
    @elevator = FactoryGirl.create(:elevator, building_name: 'Mission Control')
    5.times do
      FactoryGirl.create(
        :review,
        elevator: @elevator
      )
    end

    @user = User.first
    visit elevators_path
    click_on 'Sign In'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    click_on 'splash_screen'
    find("#elevator-#{@elevator.id}").click
  end

  scenario 'Logged-in user can see voting buttons and vote total' do
    expect(page).to have_css('#upvote', count: 5)
    expect(page).to have_css('#downvote', count: 5)
    expect(page).to have_css('.vote-total', count: 5)
  end

  scenario 'Logged-in user can vote up once' do
    review = Review.all[4]
    within(:css, "#review-#{review.id}") do
      click_on 'upvote'
    end

    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('1')
      expect(page).to_not have_content('0')
    end
  end

  scenario 'Logged-in user can vote down once' do
    review = Review.all[2]
    within(:css, "#review-#{review.id}") do
      click_on 'downvote'
    end

    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('-1')
      expect(page).to_not have_content('0')
    end
  end

  scenario 'Logged-in user cannot vote up or down on own reviews' do

    review = FactoryGirl.create(
      :review,
      elevator: @elevator,
      user: @user
    )
    visit elevator_path(@elevator)
    within(:css, "#review-#{review.id}") do
      click_on 'upvote'
    end

    expect(page).to have_content('You cannot vote on your own reviews')
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('1')
    end

    within(:css, "#review-#{review.id}") do
      click_on 'downvote'
    end

    expect(page).to have_content('You cannot vote on your own reviews')
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('-1')
    end
  end

  scenario 'Logged-in user can erase vote by clicking same button twice' do
    review = Review.first
    within(:css, "#review-#{review.id}") do
      2.times { click_on 'upvote' }
    end
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('1')
      expect(page).to_not have_content('2')
    end

    within(:css, "#review-#{review.id}") do
      2.times { click_on 'downvote' }
    end
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('0')
      expect(page).to_not have_content('-1')
      expect(page).to_not have_content('-2')
    end
  end

  scenario 'Logged-in user can change direction of vote by clicking opposite vote button' do
    review = Review.last
    within(:css, "#review-#{review.id}") do
      click_on 'upvote'
      click_on 'downvote'
    end
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('-1')
    end
    within(:css, "#review-#{review.id}") do
      2.times { click_on 'downvote' }
      click_on 'upvote'
    end
    within(:css, "#vote-total-#{review.id}") do
      expect(page).to have_content('1')
    end
  end

end
