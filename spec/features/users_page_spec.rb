require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryBot.create :user }
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:brewery2) { FactoryBot.create :brewery, name: "Testipanimo" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "Paras Olut", style: "IPA", brewery:brewery2 }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "has ratings shown on user's page" do
    FactoryBot.create :rating, beer: beer1, score: 15, user: user
    FactoryBot.create :rating, beer: beer2, score: 20, user: user

    visit user_path(user)
    expect(page).to have_content 'Iso 3 15'
    expect(page).to have_content 'Karhu 20'
  end

  it "can remove a rating successfully" do
    FactoryBot.create :rating, beer: beer1, score: 15, user: user

    sign_in(username: "Pekka", password: "Foobar1")
    visit user_path(user)

    expect{
      click_button "delete"
    }.to change{Rating.count}.from(1).to(0)
  end

  it "has favorite beer style and brewery shown on user's page" do
    FactoryBot.create :rating, beer: beer1, score: 15, user: user
    FactoryBot.create :rating, beer: beer2, score: 20, user: user
    FactoryBot.create :rating, beer: beer3, score: 45, user: user

    visit user_path(user)
    expect(page).to have_content "User's favorite beer style is IPA."
    expect(page).to have_content "User's favorite brewery is Testipanimo."
  end
end