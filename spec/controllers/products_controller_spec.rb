# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  render_views

  describe "GET #index" do
    subject { get :index }

    let(:products) { create_list(:product, 3, price_cents: 1123) }

    before { products }

    it { is_expected.to have_http_status(:ok) }

    it "responds with 3 products" do
      expect(json.size).to eq(products.count)
    end

    it "responds with correct json structure", :aggregate_failures do
      expected_product = products.first
      json_product = json.first

      expect(json_product["id"]).to eq(expected_product.id)
      expect(json_product["code"]).to eq(expected_product.code)
      expect(json_product["name"]).to eq(expected_product.name)
      expect(json_product["price"]).to eq("€11.23")
    end

    context "when there are no products" do
      let(:products) { [] }

      it "responds with empty array" do
        expect(json.size).to eq(0)
      end
    end
  end
end
