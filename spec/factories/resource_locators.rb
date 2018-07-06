FactoryBot.define do
  factory :resource_locator do
    given_url Faker::Internet.url(SHORT_API_URL)
    clicks [1,2,3,4,5,6].sample
  end
end