require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short (<4) password" do
    user = User.create username: "Pekka", password: "Ab1", password_confirmation: "Ab1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password without any numbers in it" do
    user = User.create username: "Pekka", password: "LongSecret", password_confirmation: "LongSecret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      brewery = FactoryBot.create(:brewery)
      create_beers_with_many_ratings({user: user}, "Lager", brewery, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, "Lager", brewery, 25)
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer, style: "IPA")
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq("IPA")
    end

    it "is the one with highest average rating if several rated" do
      brewery = FactoryBot.create(:brewery)
      create_beers_with_many_ratings({user: user}, "Lager", brewery, 10, 21, 15, 5, 5)
      create_beers_with_many_ratings({user: user}, "IPA", brewery, 15, 20, 20, 15, 20)
    
      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = FactoryBot.create(:brewery, name: "BrewDog")
      beer = FactoryBot.create(:beer, brewery: brewery)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_brewery).to eq("BrewDog")
    end

    it "is the one with highest average rating if several rated" do
      brewery1 = FactoryBot.create(:brewery, name: "StewCat")
      create_beers_with_many_ratings({user: user}, "Lager", brewery1, 10, 21, 15, 5, 5)
      brewery2 = FactoryBot.create(:brewery, name: "BrewDog")
      create_beers_with_many_ratings({user: user}, "IPA", brewery2, 15, 20, 20, 15, 20)
    
      expect(user.favorite_brewery).to eq("BrewDog")
    end
  end

  def create_beer_with_rating(object, style, brewery, score)
    beer = FactoryBot.create(:beer, style: style, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beers_with_many_ratings(object, style, brewery, *scores)
    scores.each do |score|
      create_beer_with_rating(object, style, brewery, score)
    end
  end
end