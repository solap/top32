require "spec_helper"

describe TeamBuilder do
  describe "get_team_details" do
    it "returns 'none' when player has no team" do
        #post = Post.new
        post = FactoryGirl.create(:post, name: "kkdd")
        #post.name = "yadda"
        yadda = post.get_team_details
        yadda[:team_name].should_not be ("none")  #how do i say "not be empty?"
    end
    it "returns details[] when player has a team" do
        #post = Post.new
        post = FactoryGirl.create(:post, name: "rule18")
        #post.name = "yadda"
        yadda = post.get_team_details
        puts "**********"
        puts yadda.to_a
        yadda[:name].should eq("rule18")
        yadda[:team_name].should_not be ("")  #how do i say "not be empty?"
    end
    it "returns nil when a player no longer has a lolking page" do
        post = FactoryGirl.create(:post, name: "tamtar")
        yadda = post.get_team_details
        yadda.should eq(nil)
    end

  end
  describe "is_eligible?" do
    it "returns a false if post.name is not one of a list" do
      post = FactoryGirl.create(:post, name: "freddie", team_name: "Team Solo Mid")
      post.is_eligible?.should be (false)
    end
  end
end