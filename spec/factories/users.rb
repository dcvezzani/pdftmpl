FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    # confirmed_at Date.today
    pay_rate 1.5
  end
end
