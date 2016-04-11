require 'rails_helper'

feature 'Voting buttons for reviews:' do

  before :each do
    FactoryGirl.create(:admin, email: 'admin@admin.com')
    5.times { FactoryGirl.create(:user) }
    @elevator = FactoryGirl.create(:elevator, building_name: 'Mission Control')
    7.times do
      FactoryGirl.create(
        :review,
        elevator: @elevator
      )
    end
  end

  context 'Admins' do
    before :each do
      visit '/admins/sign_in'
      fill_in 'Email', with: 'admin@admin.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      click_on 'Mission Control'
    end

    scenario 'can see voting buttons and vote total' do
      expect(page).to have_css('.uparrow', count: 7)
      expect(page).to have_css('.downarrow', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'cannot upvote' do
      review = Review.third
      within(:css, "#review-#{review.id}") do
        click_on '.uparrow'
        expect(page).to have_content('Sorry but only users can vote for reviews')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
        end
      end
    end

    scenario 'cannot downvote' do
      review = Review.fourth
      within(:css, "#review-#{review.id}") do
        click_on '.downarrow'
        expect(page).to have_content('Sorry but only users can vote for reviews')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('-1')
        end
      end
    end
  end

  context 'Logged-out user' do
    before :each do
      visit '/'
      click_on 'Mission Control'
    end

    scenario 'can see voting buttons and vote total' do
      expect(page).to have_css('.uparrow', count: 7)
      expect(page).to have_css('.downarrow', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'is prompted to sign-in if she attempts to upvote' do
      review = Review.second
      within(:css, "#review-#{review.id}") do
        click_on '.uparrow'
        expect(page).to have_content('Please sign-in')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
        end
        fill_in 'Email', with: 'user1@user.com'
        fill_in 'Password', with: 'password'
        click_on 'Log in'
        expect(page).to have_css('.review', count: 7)
        expect(page).to_not have_content('Add Elevator')
      end
    end

    scenario 'is prompted to sign-in if she attempts to downvote' do
      review = Review.second
      within(:css, "#review-#{review.id}") do
        click_on '.downarrow'
        expect(page).to have_content('Please sign-in')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('-1')
        end
        fill_in 'Email', with: 'user1@user.com'
        fill_in 'Password', with: 'password'
        click_on 'Log in'
        expect(page).to have_css('.review', count: 7)
        expect(page).to_not have_content('Add Elevator')
      end
    end
  end

  context 'Logged-in user' do
    before :each do
      visit '/'
      click_on 'Sign In'
      fill_in 'Email', with: 'user1@user.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      click_on 'Mission Control'
    end

    scenario 'can see voting buttons and vote total' do
      expect(page).to have_css('.uparrow', count: 7)
      expect(page).to have_css('.downarrow', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'can vote up once' do
      review = Review.all[6]
      within(:css, "#review-#{review.id}") do
        click_on '.uparrow'
        within(:css, '.vote-total') do
          expect(page).to have_content('1')
          expect(page).to_not have_content('0')
        end
      end
    end

    scenario 'can vote down once' do
      review = Review.all[5]
      within(:css, "#review-#{review.id}") do
        click_on '.downarrow'
        within(:css, '.vote-total') do
          expect(page).to have_content('-1')
          expect(page).to_not have_content('0')
        end
      end
    end

    scenario 'cannot vote up or down on own reviews' do
      review = FactoryGirl(
        :review,
        elevator: @elevator,
        user: current_user
      )
      within(:css, "#review-#{review.id}") do
        click_on '.uparrow'
        expect(page).to have_content('You cannot vote on your own reviews')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
        end

        click_on '.downarrow'
        expect(page).to have_content('You cannot vote on your own reviews')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('-1')
        end
      end
    end

    scenario 'can erase vote by clicking same button twice' do
      review = Review.first
      within(:css, "#review-#{review.id}") do
        2.times { click_on '.uparrow' }
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
          expect(page).to_not have_content('2')
        end

        2.times { click_on '.downarrow' }
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('-1')
          expect(page).to_not have_content('-2')
        end
      end
    end

    scenario 'change direction of vote by clicking opposite vote button' do
      review = Review.last
      within(:css, "#review-#{review.id}") do
        click_on '.uparrow'
        click_on '.downarrow'
        within(:css, '.vote-total') do
          expect(page).to have_content('-1')
          expect(page).to_not have_content('0')
        end

        2.times { click_on '.downarrow' }
        click_on '.uparrow'
        within(:css, '.vote-total') do
          expect(page).to have_content('1')
          expect(page).to_not have_content('0')
        end
      end
    end
  end

  scenario 'Vote total displays the total of all votes by all users' do
    def user_votes(user, direction, review)
      visit '/sign_in'
      fill_in 'Email', with: user.email
      click_on 'Log in'
      click_on 'Mission Control'
      within(:css, "#review-#{review.id}") do
        click_on direction
      end
      click_on 'Sign Out'
    end

    review = Review.first
    user_votes(User.all[0], '.upvote', review)
    user_votes(User.all[1], '.downvote', review)
    user_votes(User.all[2], '.upvote', review)
    user_votes(User.all[3], '.upvote', review)
    user_votes(User.all[4], '.downvote', review)
    user_votes(User.all[5], '.upvote', review)

    visit '/'
    click_on 'Mission Control'
    within(:css, "#review-#{review.id} .vote-total") do
      expect(page).to have_content('2')
    end
  end

end