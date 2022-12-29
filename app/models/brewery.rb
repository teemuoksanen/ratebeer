class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1040 }
  validate :year_cannot_be_in_the_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def self.top(top_n)
    top = {}
    averages_sorted_n = Rating.all.joins(beer: :brewery).group('breweries.id').average('ratings.score').sort_by{ |_, v| v }.reverse.take(top_n)
    averages_sorted_n.each do |k, v| top.store(Brewery.find_by(id: k), v) end
    top
  end

  def year_cannot_be_in_the_future
    errors.add(:year, "can't be in the future") if year.present? && year > Date.today.year
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  def to_s
    name
  end
end
