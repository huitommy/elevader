require 'rails_helper'

feature 'Voting buttons for reviews:' do

  scenario 'Vote total displays the total of all votes by all users' do
    5.times { FactoryGirl.create(:user) }
    elevator = FactoryGirl.create(:elevator, building_name: 'Mission Control')
    user1 = User.all[0]
    user2 = User.all[1]
    user3 = User.all[2]
    user4 = User.all[3]
    user5 = User.all[4]
    review = FactoryGirl.create(:review, elevator: elevator, user: user5)

    def user_votes(user, direction, review)
      visit 'users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      click_on 'Mission Control'
      within(:css, "#review-#{review.id}") do
        click_on direction
      end
      click_on 'Sign Out'
    end

    user_votes(user1, 'upvote', review)
    user_votes(user2, 'downvote', review)
    user_votes(user3, 'upvote', review)
    user_votes(user4, 'upvote', review)

    visit '/'
    click_on 'Mission Control'
    within(:css, "#review-#{review.id} .vote-total") do
      expect(page).to have_content('2')
    end
  end

end