class Style < ApplicationRecord
  has_many :beers

  validates :name, presence: true

  def self.top(top_n)
    top = {}
    averages_sorted_n = Rating.all.joins(beer: :style).group('styles.id').average('ratings.score').sort_by{ |_, v| v }.reverse.take(top_n)
    averages_sorted_n.each do |k, v| top.store(Style.find_by(id: k), v) end
    top
  end

  def to_s
    name
  end
end
