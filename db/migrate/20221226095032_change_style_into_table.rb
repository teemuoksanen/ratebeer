class ChangeStyleIntoTable < ActiveRecord::Migration[7.0]
  def change
    change_table :beers do |t|
      t.rename :style, :old_style
    end
    add_reference :beers, :style, foreign_key: true
    Style.all.each do |s|
      Beer.where(old_style: s.name).update_all(style_id: s.id)
    end
    remove_column :beers, :old_style, :string
  end
end
