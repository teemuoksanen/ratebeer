require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherstackApi).to receive(:place).with("kumpula").and_return(
      Weather.new( name: "Kumpula", temperature: 0, weather_icons: ["/pixel.png"], wind_speed: 1, wind_dir: "S" )
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "Parmesan", id: 2 ) ]
    )

    allow(WeatherstackApi).to receive(:place).with("kumpula").and_return(
      Weather.new( name: "Kumpula", temperature: 0, weather_icons: ["/pixel.png"], wind_speed: 1, wind_dir: "S" )
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Parmesan"
  end

  it "if none is returned by the API, appropriate note is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [  ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end
end
