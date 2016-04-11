require 'rails_helper'

feature 'User can login and logout:' do

  before :each do
    15.times { FactoryGirl.create(:elevator) }
    15.times { FactoryGirl.create(:review) }
    visit '/'
  end

  scenario 'User sees multiple pages of elevators' do
    expect(page).to have_link('Next ›')
    expect(page).to have_link('Last »')

  end
end
