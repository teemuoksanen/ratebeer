class Style < ApplicationRecord
  has_many :beers

  validates :name, presence: true

  def self.top(n)
    top = {}
    averages_sorted_n = Rating.all.joins(beer: :style).group('styles.id').average('ratings.score').sort_by{|k,v| v}.reverse.take(n)
    averages_sorted_n.each do |k, v| top.store(Style.find_by(id: k), v.round(1).to_f) end
    top
  end

  def to_s
    name
  end
end
