require "spec_helper"

describe Api::V1::ProductsController do
  describe "/index" do
    let(:user) { create(:user) }
    let!(:buyer) { create(:organization, :single_location, :buyer, users: [user]) }
    let!(:seller) { create(:organization, :seller, :single_location, name: 'First Seller') }
    let!(:second_seller) { create(:organization, :seller, :single_location, name: 'Second Seller') }

    let(:market) { create(:market, :with_addresses, organizations: [buyer, seller, second_seller]) }
    let!(:delivery) { create(:delivery_schedule, market: market) }

    # Products
    let!(:bananas) { create(:product, name: "Bananas", organization: seller, delivery_schedules: [delivery]) }
    let!(:bananas_lot) { create(:lot, product: bananas) }
    let!(:bananas_price_buyer_base) do
      create(:price, :past_price, market: market, product: bananas, min_quantity: 1, organization: buyer)
    end

    let!(:bananas2) { create(:product, name: "Bananas", organization: second_seller, delivery_schedules: [delivery]) }
    let!(:bananas2_lot) { create(:lot, product: bananas2) }
    let!(:bananas2_price_buyer_base) do
      create(:price, :past_price, market: market, product: bananas2, min_quantity: 1, organization: buyer)
    end

    let!(:kale) { create(:product, name: "Kale", organization: seller, delivery_schedules: [delivery]) }
    let!(:kale_lot) { create(:lot, product: kale) }
    let!(:kale_price_buyer_base) do
      create(:price, :past_price, market: market, product: kale, min_quantity: 1)
      create(:price, :past_price, market: market, product: kale, min_quantity: 10, sale_price: 1.75)
    end


    before do
      switch_to_subdomain market.subdomain
      sign_in user

      @banana_result = {"id"=>bananas.id, "name"=>"Bananas", "second_level_category_name"=>"Apples", "seller_name"=>"First Seller", "pricing"=>"$3.00 for 1+", "unit_with_description"=>"boxes"}
      @banana2_result = {"id"=>bananas2.id, "name"=>"Bananas", "second_level_category_name"=>"Apples", "seller_name"=>"Second Seller", "pricing"=>"$3.00 for 1+", "unit_with_description"=>"boxes"}
      @kale_result = {"id"=>kale.id, "name"=>"Kale", "second_level_category_name"=>"Apples", "seller_name"=>"First Seller", "pricing"=>"$3.00 for 1+, $1.75 for 10+", "unit_with_description"=>"boxes"}
    end

    def get_products(params)
      get :index, params
      JSON.parse(response.body)["products"]
    end


    it "returns a paginated list of products" do
      products = get_products(start: 2)
      expect(products).to eq([@kale_result])
      products = get_products(start: 1)
      expect(products).to eq([@banana2_result, @kale_result])
      products = get_products(start: 0)
      expect(products).to eq([@banana_result, @banana2_result, @kale_result])
    end
  end
end