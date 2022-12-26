FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :style do
    name { "Lager" }
    description { "This is basic." }
  end

  factory :beer do
    name { "anonymous" }
    style # olueeseen liittyvä tyyli luodaan style-tehtaalla
    brewery # olueeseen liittyvä panimo luodaan brewery-tehtaalla
  end

  factory :rating do
    score { 10 }
    beer # reittaukseen liittyvä olut luodaan beer-tehtaalla
    user # reittaukseen liittyvä user luodaan user-tehtaalla
  end
end