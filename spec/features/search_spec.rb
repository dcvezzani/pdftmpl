require "rails_helper"
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

RSpec.feature "Looking up recipes", :type => :feature, js: true do

  before(:each) do
    user = FactoryGirl.create(:user)
    login_as(user , :scope => :user)   ## our instant magic authentication
  end

  scenario "finding recipes" do
    visit '/'
    fill_in "keywords", with: "baked"
    click_on "Search"

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end

end
