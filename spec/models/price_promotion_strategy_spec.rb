# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricePromotionStrategy, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:quantity_to_buy) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:products).dependent(:nullify) }
  end

  describe "#calculate_discount_money" do
    it { expect { subject.calculate_discount_money }.to raise_error(NotImplementedError) }
  end
end
