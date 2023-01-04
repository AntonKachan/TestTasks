class CreatePricePromotionStrategies < ActiveRecord::Migration[7.0]
  def change
    create_table :price_promotion_strategies do |t|
      t.string :type
      t.float :amount
      t.integer :quantity_to_buy
      t.integer :quantity_to_discount

      t.timestamps
    end
  end
end
