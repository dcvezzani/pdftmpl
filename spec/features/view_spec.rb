require "rails_helper"

# kudos: http://blog.pixarea.com/2013/01/making-rspec-feature-specs-easy-with-devise/
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

RSpec.feature "Viewing a recipe", :type => :feature, js: true do
  
  before(:each) do
    user = FactoryGirl.create(:user)
    login_as(user , :scope => :user)   ## our instant magic authentication

    Recipe.create!(name: 'Baked Potato w/ Cheese', instructions: "nuke for 20 minutes")
    Recipe.create!(name: 'Baked Brussel Sprouts', instructions: 'Slather in oil, and roast on high heat for 20 minutes')
  end
  
  scenario "view one recipe" do
    visit '/#/recipes'
    fill_in "keywords", with: "baked"
    click_on "Search"

    click_on "Baked Brussel Sprouts"

    expect(page).to have_content("Baked Brussel Sprouts")
    expect(page).to have_content("Slather in oil")

    click_on "Back"

    expect(page).to     have_content("Baked Brussel Sprouts")
    expect(page).to_not have_content("Slather in oil")
  end
end
