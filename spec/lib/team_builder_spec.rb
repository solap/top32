require "spec_helper"

describe TeamBuilder do
  describe "get_team_details" do
    it "returns 'none' when player has no team" do
        #post = Post.new
        post = FactoryGirl.create(:post, name: "yadda")
        #post.name = "yadda"
        yadda = post.get_team_details
        yadda.should eq("none")
    end
    it "returns details[] when player has a team" do
        #post = Post.new
        post = FactoryGirl.create(:post, name: "tamtar")
        #post.name = "yadda"
        yadda = post.get_team_details
        yadda[:name].should eq("tamtar")
        yadda[:team_name].should #how do i say "not be empty?"

    end
  end
end