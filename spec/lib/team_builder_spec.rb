require "team_builder" #loading the file with a pre-pended lib

describe "get_team_details" do

  it "returns 'none' when player has no team" do
      post = Post.new
      post.name = "yadda"
      details = post.get_team_details
      yadda.should eq("none")
  end
end