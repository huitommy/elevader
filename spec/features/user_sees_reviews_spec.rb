require 'rails_helper'

RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  end
end

feature 'User visits elevator page:' do

  let!(:elevator) { FactoryGirl.create(:elevator, building_name: 'Cool Elevator') }
  let!(:review1) { FactoryGirl.create(:review, elevator: elevator, total_votes: 7) }
  let!(:review2) { FactoryGirl.create(:review, elevator: elevator, total_votes: 3) }
  let!(:review3) { FactoryGirl.create(:review, elevator: elevator, total_votes: 7) }
  let!(:review4) { FactoryGirl.create(:review, elevator: elevator, total_votes: -9) }
  let!(:review5) { FactoryGirl.create(:review, elevator: elevator, total_votes: 1) }
  let!(:review6) { FactoryGirl.create(:review, elevator: elevator, total_votes: 0) }

  scenario 'user sees reviews sorted by vote number and review date' do
    visit elevators_path
    click_on 'Cool Elevator'

    def check_order(earlier_review, later_review)
      earlier_content = 'id="review-' + earlier_review.id.to_s + '"'
      later_content = 'id="review-' + later_review.id.to_s + '"'
      expect(earlier_content).to appear_before(later_content)
    end

    check_order(review1, review2)
    check_order(review3, review2)
    check_order(review3, review1)
    check_order(review1, review4)
    check_order(review6, review4)
    check_order(review5, review4)
  end
end
