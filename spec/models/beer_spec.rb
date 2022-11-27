require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery) { Brewery.new name: "Test Brewery", year: 2000 }
  
  it "with a name, style and brewery set is saved" do
    beer = Beer.create name: "Test Beer", style: "Lager", brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "without a name is not saved" do
    beer = Beer.create style: "Lager", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "without a style is not saved" do
    beer = Beer.create name: "Test Beer", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end