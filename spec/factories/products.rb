# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:code) { |n| "CF#{n}" }
    name { "Coffee" }
    price_cents { 1123 }
  end
end
