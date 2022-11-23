class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    self.ratings.average(:score).to_f
  end

  def to_s
    self.name + " (" + self.brewery.name + ")"
  end

end
