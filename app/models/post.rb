class Post < ActiveRecord::Base
  attr_accessible :name, :team_elo, :team_name
end
