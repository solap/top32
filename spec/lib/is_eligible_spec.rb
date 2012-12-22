require "is_eligible" #loading the file with a pre-pended lib
require "spec_helper"
describe "is_eligible" do

  it "returns false if passed in a string which is one of the three" do
    #expect(Gol.new.board).to be_kind_of Board
    yadda = is_eligible("Team Solo Mid")
    yadda.should eq(false)
  end

  it "returns true if passed in a string which is not one of the three" do
    #expect(Gol.new.board).to be_kind_of Board
    yadda = is_eligible("yadda")
    yadda.should eq(true)
  end

  it "returns nil if passed in a non-string" do
    yadda = is_eligible(45)
    yadda.should eq(nil)
  end
end