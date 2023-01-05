# frozen_string_literal: true

require "rails_helper"

RSpec.describe InvoicesController, type: :controller do
  render_views

  describe "GET #index" do
    subject { get :index, params: { product_ids: product_ids } }

    context "when product_ids is empty" do
      let(:product_ids) { [] }

      it { is_expected.to have_http_status(:ok) }

      it "responds with correct json" do
        expect(json["totalPrice"]).to eq("€0.00")
      end
    end

    context "with product_ids" do
      let(:buy_x_get_y_free) do
        build(:percent_promotion_strategy, amount: 100, quantity_to_buy: 1, quantity_to_discount: 1)
      end
      let(:buy_x_get_cents_discount) { build(:cents_promotion_strategy, amount: 50, quantity_to_buy: 3) }
      let(:buy_x_get_percent_discount) { build(:percent_promotion_strategy, amount: 33.3333, quantity_to_buy: 3) }

      let(:product1) { create(:product, price_cents: 311, price_promotion_strategy: buy_x_get_y_free)  }
      let(:product2) { create(:product, price_cents: 500, price_promotion_strategy: buy_x_get_cents_discount)  }
      let(:product3) { create(:product, price_cents: 1123, price_promotion_strategy: buy_x_get_percent_discount)  }

      context "when buy X get Y free applies" do
        let(:product_ids) { [ product1.id, product1.id ] }

        it { expect(json["totalPrice"]).to eq("€3.11") }
      end

      context "when buy X get Y cents discount applies" do
        let(:product_ids) { [ product2.id, product2.id, product1.id, product2.id ] }

        it { expect(json["totalPrice"]).to eq("€16.61") }
      end

      context "when buy X get Y percent discount applies" do
        let(:product_ids) { [ product1.id, product3.id, product2.id, product3.id, product3.id ] }

        it { expect(json["totalPrice"]).to eq("€30.57") }
      end
    end
  end
end
