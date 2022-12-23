require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

  before :each do
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is created with valid information" do
    visit new_beer_path

    fill_in('beer[name]', with: 'Testiolut')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    click_button('Create Beer')

    expect(page).to have_content 'Beers'
    expect(page).to have_content 'Testiolut'
  end

  it "is not created if no name is given" do
    visit new_beer_path

    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    click_button('Create Beer')

    expect(Beer.count).to eq(0)
    expect(page).to have_content "New beer"
    expect(page).to have_content "Name can't be blank"
  end
end