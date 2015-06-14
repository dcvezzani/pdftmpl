require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  include Capybara::DSL

  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "should be redirected to signin" do
      get :index
      expect( response ).to redirect_to( new_user_session_path )
    end
  end

  describe "authenticated user" do
    before :each do
      # This simulates an anonymous user
      login_with create( :user )
    end

    describe "finding recipes" do
      it "should search for baked and find results" do
        visit '/'
        debugger
        fill_in "keywords", with: "baked"
        click_on "Search"

        expect(page).to have_content("Baked Potato")
        expect(page).to have_content("Baked Brussel Sprouts")
      end
    end
  end

end
