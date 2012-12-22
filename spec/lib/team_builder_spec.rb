require "spec_helper.rb"

describe "team_builder" do
  describe "get_team_details" do

    it "returns 'none' when player has no team" do
        post = Post.new
        post.name = "yadda"
        yadda = post.get_team_details
        yadda.should eq("none")
    end
  end
end