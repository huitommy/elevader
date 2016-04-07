require 'rails_helper'

feature 'Search bar:' do

  before :all do
    FactoryGirl(:user, email: 'email@email.com', password: 'password')
    FactoryGirl(:admin, email: 'email@email.com', password: 'password')
    FactoryGirl(:elevator, building_name: 'Nice building with nice elevator')
    FactoryGirl(:elevator, building_name: 'Stinky elevator')
    FactoryGirl(:elevator, building_name: 'Stinky yet NICE elevator')
    FactoryGirl(:elevator, building_name: 'Idiotic building')
    FactoryGirl(:elevator, building_name: 'This place sucks')
    FactoryGirl(:elevator, building_name: 'The White House')
    FactoryGirl(:elevator, building_name: 'The White Mountains')
    FactoryGirl(:elevator, building_name: 'The White Whale')
  end

  scenario 'Non-logged-in user searches for a specific elevator' do
    visit '/'
    fill_in 'Search', with: 'nice'
    click_on 'Search'

    expect(page).to have_css('.elevator', count: 2)
    expect(page).to have_content('Nice building with nice elevator')
    expect(page).to have_content('Stinky yet NICE elevator')
    expect(page).to_not have_content('Stinky elevator')
  end

  scenario 'Logged-in user searches for a specific elevator' do
    visit '/'
    click 'Sign In'
    fill_in 'Email', with: 'email@email'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    fill_in 'Search', with: 'white'
    click_on 'Search'

    expect(page).to have_css('.elevator', count: 3)
    expect(page).to have_content('The White House')
    expect(page).to have_content('The White Mountains')
    expect(page).to have_content('The Whale')
  end

  scenario 'Admin searches for a specific elevator' do
    visit '/admins/sign_in'
    fill_in 'Email', with: 'email@email'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    fill_in 'Search', with: 'place'
    click_on 'Search'

    expect(page).to have_css('.elevator', count: 1)
    expect(page).to have_content('This place sucks')
  end

  scenario 'User enters search term for which there are no matches' do
    visit '/'
    fill_in 'Search', with: 'BEST ELEVAYDOOR EVAH'
    click_on 'Search'

    expect(page).to have_css('.elevator', count: 0)
    expect(page).to have_content("Sorry but we couldn't find that elevator for you")
  end

  scenario 'user can go to elevator show pages from results' do
    visit '/'
    fill_in 'Search', with: 'nice'
    click_on 'Search'

    click_on 'Stinky yet NICE elevator'
    expect(page).to have_content('Stinky yet NICE elevator')
    expect(page).to_not have_content('Nice building with nice elevator')
    expect(page).to have_content('State: teststate')
    expect(page).to have_content('City: testcity')
    expect(page).to have_content('City: testcity')
    expect(page).to have_content('Address: testaddress')
  end

end