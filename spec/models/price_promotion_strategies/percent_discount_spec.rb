# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricePromotionStrategies::PercentDiscount, type: :model do
  it { expect(described_class).to be < PricePromotionStrategy }

  describe "Validations" do
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_numericality_of(:amount).is_less_than_or_equal_to(100) }
  end

  describe "#calculate_discount_money" do
    subject { instance.calculate_discount_money(quantity, base_price) }

    let(:instance) do
      described_class.new(
        amount: amount,
        quantity_to_buy: quantity_to_buy,
        quantity_to_discount: quantity_to_discount
      )
    end
    let(:base_price) { 1000 }

    context "when discount applies for any quantity" do
      let(:quantity) { rand(100) }
      let(:amount) { 999 }
      let(:quantity_to_buy) { 1 }
      let(:quantity_to_discount) { nil }

      it { is_expected.to eq(Money.new(quantity * base_price * amount / 100.0)) }
    end

    context "when discount applies for specific quantity" do
      let(:amount) { 99 }
      let(:quantity_to_buy) { 2 }
      let(:quantity_to_discount) { 2 }

      context "when quantity less than 3" do
        let(:quantity) { 2 }

        it "doesn't apply for any item" do
          is_expected.to eq(Money.zero)
        end
      end

      context "when quantity = 3" do
        let(:quantity) { 3 }

        it "applies only for one item" do
          is_expected.to eq(Money.new(base_price * amount / 100.0))
        end
      end

      context "when quantity = 4" do
        let(:quantity) { 4 }

        it "applies for two items" do
          is_expected.to eq(Money.new(base_price * amount / 100.0 * 2))
        end
      end

      context "when quantity = 5" do
        let(:quantity) { 5 }

        it "applies for two items" do
          is_expected.to eq(Money.new(base_price * amount / 100.0 * 2))
        end
      end
    end
  end
end
