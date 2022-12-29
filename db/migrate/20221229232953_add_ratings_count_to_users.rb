class AddRatingsCountToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :ratings_count, :integer, default: 0
    User.reset_column_information
    User.all.each do |u|
      User.update_counters u.id, ratings_count: u.ratings.length
    end
  end
  def down
    remove_column :users, :ratings_count
  end
end
