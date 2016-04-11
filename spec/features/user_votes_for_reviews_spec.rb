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
      expect(page).to have_css('#upvote', count: 7)
      expect(page).to have_css('#downvote', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'cannot upvote' do
      review = Review.third
      within(:css, "#review-#{review.id}") do
        click_on 'upvote'
      end
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

    scenario 'cannot downvote' do
      review = Review.fourth
      within(:css, "#review-#{review.id}") do
        click_on 'downvote'
      end
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'Logged-out user' do
    before :each do
      visit '/'
      click_on 'Mission Control'
    end

    scenario 'can see voting buttons and vote total' do
      expect(page).to have_css('#upvote', count: 7)
      expect(page).to have_css('#downvote', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'is prompted to sign-in if she attempts to upvote' do
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

    scenario 'is prompted to sign-in if she attempts to downvote' do
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

  context 'Logged-in user' do
    before :each do
      @user = User.first
      visit '/'
      click_on 'Sign In'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      click_on 'Mission Control'
    end

    scenario 'can see voting buttons and vote total' do
      expect(page).to have_css('#upvote', count: 7)
      expect(page).to have_css('#downvote', count: 7)
      expect(page).to have_css('.vote-total', count: 7)
    end

    scenario 'can vote up once' do
      review = Review.all[6]
      within(:css, "#review-#{review.id}") do
        click_on 'upvote'
      end

      within(:css, "#review-#{review.id} .vote-total") do
        expect(page).to have_content('1')
        expect(page).to_not have_content('0')
      end
    end

    scenario 'can vote down once' do
      review = Review.all[6]
      within(:css, "#review-#{review.id}") do
        click_on 'downvote'
      end

      within(:css, "#review-#{review.id} .vote-total") do
        expect(page).to have_content('-1')
        expect(page).to_not have_content('0')
      end
    end

    scenario 'cannot vote up or down on own reviews' do
      review = FactoryGirl.create(
        :review,
        elevator: @elevator,
        user: @user
      )
      visit '/'
      click_on 'Mission Control'
      within(:css, "#review-#{review.id}") do
        click_on 'upvote'
        binding.pry
        expect(page).to have_content('You cannot vote on your own reviews')
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
        end

        click_on 'downvote'
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
        2.times { click_on 'upvote' }
        within(:css, '.vote-total') do
          expect(page).to have_content('0')
          expect(page).to_not have_content('1')
          expect(page).to_not have_content('2')
        end

        2.times { click_on 'downvote' }
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
        click_on 'upvote'
        click_on 'downvote'
        within(:css, '.vote-total') do
          expect(page).to have_content('-1')
          expect(page).to_not have_content('0')
        end

        2.times { click_on 'downvote' }
        click_on 'upvote'
        within(:css, '.vote-total') do
          expect(page).to have_content('1')
          expect(page).to_not have_content('0')
        end
      end
    end
  end

  scenario 'Vote total displays the total of all votes by all users' do
    review = Review.first
    
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

    user_votes(User.all[0], 'upvote', review)
    user_votes(User.all[1], 'downvote', review)
    user_votes(User.all[2], 'upvote', review)
    user_votes(User.all[3], 'upvote', review)
    user_votes(User.all[8], 'downvote', review)
    user_votes(User.all[9], 'upvote', review)

    visit '/'
    click_on 'Mission Control'
    within(:css, "#review-#{review.id} .vote-total") do
      expect(page).to have_content('2')
    end
  end

end