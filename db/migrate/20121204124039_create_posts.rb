class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.integer :team_elo
      t.string :team_name

      t.timestamps
    end
  end
end
