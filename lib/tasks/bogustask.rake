task :get_latest => :environment do
	Post.create_team_list
end