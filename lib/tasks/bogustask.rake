task :get_latest => :environment do
	Post.create_team_list
end
task :remove_dupes => :environment do
  puts "Post.count: #{Post.count}"
  Post.all.each do |post|
    Post.where("id<>? and name=?", post.id, post.name).destroy_all
  end
  puts "Post.count: #{Post.count}"
end