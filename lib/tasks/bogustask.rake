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
  blank_rows = Post.where("name is null or name=''")
  puts "NUMBER OF BLANK ROWS: #{blank_rows.count.to_s}"
  blank_rows.destroy_all
  puts "Done"
end
task :purge_players => :environment do
  min_elo = 1600
  puts "Nuking all players with lower than #{min_elo} elo."
  puts "Total rows: #{Post.count}"
  nuke_rows = Post.where("team_elo<#{min_elo}")
  puts "NUMBER OF LOW ELO ROWS: #{nuke_rows.count.to_s}"
  nuke_rows.destroy_all
  low_elo_rows = Post.where("team_elo is NULL")
  puts "NUMBER OF NIL ROWS: #{low_elo_rows.count.to_s}"
  low_elo_rows.destroy_all
  puts "Done"
end
task :remove_blah => :environment do
  puts "Nuking all rows with blank names."
  blah_rows = Post.where("team_name is blah")
  puts "NUMBER OF BLAH ROWS: #{blah_rows.count.to_s}"
  blah_rows.destroy_all
  puts "Done"
end
