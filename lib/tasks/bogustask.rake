task :get_latest => :environment do
	Post.create_team_list
end
task :remove_dupes => :environment do
  puts "Post.count: #{Post.count}"
  Post.all.each do |post|
    dupe_collection=Post.where("id!=? and name=?", post.id, post.name)
    dupe_collection.all.each do |dupe|
      dupe.destroy
    end
  end
  puts "Post.count: #{Post.count}"
end