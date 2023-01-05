# frozen_string_literal: true

class GetInvoice
  def initialize(product_ids:)
    @product_ids = product_ids || []
  end

  def call
    { total_price: total_price }
  end

  private

  attr_reader :product_ids

  def total_price
    products_by_quantity.sum(Money.new(0)) do |(product, quantity)|
      Money.new(product.price_cents * quantity) - product.discount_for(quantity: quantity)
    end
  end

  def products_by_quantity
    meal_ids_by_quantity = product_ids.group_by(&:itself).transform_values(&:count)
    meal_ids_by_quantity.transform_keys do |product_id|
      products.find { |product| product.id == product_id }
    end
  end

  def products
    @products ||= Product.includes(:price_promotion_strategy).find(product_ids)
  end
end
