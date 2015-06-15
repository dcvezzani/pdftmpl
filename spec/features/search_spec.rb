require "rails_helper"

# kudos: http://blog.pixarea.com/2013/01/making-rspec-feature-specs-easy-with-devise/
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

RSpec.feature "Looking up recipes", :type => :feature, js: true do

  # before(:all) do
  #   Recipe.create!(name: 'Baked Potato w/ Cheese')
  #   Recipe.create!(name: 'Garlic Mashed Potatoes')
  #   Recipe.create!(name: 'Potatoes Au Gratin')
  #   Recipe.create!(name: 'Baked Brussel Sprouts')
  # end

  before(:each) do
    user = FactoryGirl.create(:user)
    login_as(user , :scope => :user)   ## our instant magic authentication

    Recipe.create!(name: 'Baked Potato w/ Cheese')
    Recipe.create!(name: 'Garlic Mashed Potatoes')
    Recipe.create!(name: 'Potatoes Au Gratin')
    Recipe.create!(name: 'Baked Brussel Sprouts')
  end

  scenario "searching recipes" do
    visit '/recipes/index?format=json&keywords=baked'

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
    expect(page).to have_content("\"instructions\"")
    expect(page).to have_content("\"id\"")
    expect(page).to have_content("\"name\"")
  end

  scenario "finding recipes" do
    visit '/#/recipes'
    fill_in "keywords", with: "baked"
    click_on "Search"

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end

end
