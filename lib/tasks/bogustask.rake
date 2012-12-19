gem 'pg'
task :get_latest => :environment do
	Post.create_team_list
end
task :remove_dupes => :environment do
  tadd_rocks = Post.select("name, count(name) as total").group("name")
  tadd_rocks.each do |t|
    puts "0: #{t.name}  1: #{t.total}"
    #puts t.inspect
  end
  Post.all.each do |post|
    Post.where("id<>? and name=?", post.id, post.name).destroy_all
  end
  tadd_rocks.each do |t|
   puts t.inspect
  end
end
task :list_names => :environment do
  puts "***************************"
  @tags=Post.find(:all).sort_by
  yadda=@tags.sort_by { |t| t.name }
  yadda.each do |u|
    puts u.name
  end
end
task :remove_blanks => :environment do
  puts "Nuking all rows with blank names."
  Post.where("name is null or name=''").destroy_all
  puts "Done"
end