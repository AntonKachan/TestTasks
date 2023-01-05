# frozen_string_literal: true

puts "Create PricePromotionStrategies"
green_tea_promotion = PricePromotionStrategies::PercentDiscount.create(amount: 100, quantity_to_buy: 1, quantity_to_discount: 1)
strawberry_promotion = PricePromotionStrategies::CentsDiscount.create(amount: 50, quantity_to_buy: 3)
coffee_promotion = PricePromotionStrategies::PercentDiscount.create(amount: 33.3333, quantity_to_buy: 3)

puts "Create Products"
Product.create(code: 'GR1', name: 'Green Tea', price_cents: 311, price_promotion_strategy: green_tea_promotion)
Product.create(code: 'SR1', name: 'Strawberries', price_cents: 500, price_promotion_strategy: strawberry_promotion)
Product.create(code: 'CF1', name: 'Coffee', price_cents: 1123, price_promotion_strategy: coffee_promotion)
