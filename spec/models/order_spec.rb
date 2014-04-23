require 'spec_helper'

describe Order do
  context "validations" do
    it "requires an organization id" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:organization_id)
    end

    it "requires a market id" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:market_id)
    end

    it "requires a delivery id" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_id)
    end

    it "requires a order number" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:order_number)
    end

    it "requires a placed_at date" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:placed_at)
    end

    it "requires delivery fees" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_fees)
    end

    it "requires a total cost" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:total_cost)
    end

    it "requires a delivery address" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_address)
    end

    it "requires a delivery city" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_city)
    end

    it "requires a delivery state" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_state)
    end

    it "requires a delivery zip" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:delivery_zip)
    end

    it "requires a billing organization name" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:billing_organization_name)
    end

    it "requires a billing address" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:billing_address)
    end

    it "requires a billing city" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:billing_city)
    end

    it "requires a billing state" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:billing_state)
    end

    it "requires a billing zip" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:billing_zip)
    end


    it "requires a payment status" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:payment_status)
    end

    it "requires a payment method" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:payment_method)
    end

    it "requires at least one order item to be valid" do
      expect(subject).to be_invalid
      expect(subject).to have(1).error_on(:items)
    end
  end

  describe ".orders_for_buyer" do
    context "admin" do
      let(:market)       { create(:market) }
      let(:organization) { create(:organization, markets: [market]) }
      let!(:user)        { create(:user, :admin) }
      let!(:order)       { create(:order, :with_items, organization: organization, market: market) }
      let!(:other_order) { create(:order, :with_items, organization_id: 0, market: market) }

      it "returns all orders" do
        orders = Order.orders_for_buyer(user)

        expect(orders).to eq(Order.all)
      end
    end

    context "market manager" do
      let!(:user)        { create(:user, :market_manager) }
      let(:market)       { user.managed_markets.first }
      let(:other_market) { create(:market) }
      let(:organization) { create(:organization, markets: [market]) }
      let(:org2)         { create(:organization, markets: [other_market], users: [user])}
      let!(:order)       { create(:order, :with_items, organization: organization, market: market) }
      let!(:other_order) { create(:order, :with_items,organization_id: 0, market: market) }
      let!(:other_market_order) { create(:order, :with_items, organization_id: 0, market: other_market) }
      let!(:valid_other_market_order) { create(:order, :with_items, organization: org2, market: other_market) }

      it "returns only managed markets orders" do
        orders = Order.orders_for_buyer(user)

        expect(orders.count).to eq(3)
        expect(orders).to include(order, other_order, valid_other_market_order)
      end
    end

    context "user" do
      let(:market)       { create(:market) }
      let(:organization) { create(:organization, markets: [market]) }
      let!(:user)        { create(:user, organizations:[organization]) }
      let!(:order)       { create(:order, :with_items, organization: organization, market: market) }
      let!(:other_order) { create(:order, :with_items, organization_id: 0, market: market) }

      it 'returns only the organizations orders' do
        orders = Order.orders_for_buyer(user)

        expect(orders.count).to eq(1)
        expect(orders).to include(order)
      end
    end
  end

  describe ".orders_for_seller" do
    context "admin" do
      let(:market)       { create(:market) }
      let(:organization) { create(:organization, markets: [market]) }
      let!(:user)        { create(:user, :admin) }
      let!(:order)       { create(:order, :with_items, organization: organization, market: market) }
      let!(:other_order) { create(:order, :with_items, organization_id: 0, market: market) }

      it "returns all orders" do
        orders = Order.orders_for_seller(user)

        expect(orders).to eq(Order.all)
      end
    end

    context "market_manager" do
      let!(:user)    { create(:user, :market_manager) }
      let!(:market1) { user.managed_markets.first }
      let!(:market2) { create(:market) }
      let!(:org1)    { create(:organization, users: [user], markets: [market2]) }
      let!(:org2)    { create(:organization, markets: [market2]) }
      let!(:product1) { create(:product, :sellable, organization: org1) }
      let!(:product2) { create(:product, :sellable, organization: org2) }
      let!(:product3) { create(:product, :sellable, organization: org1) }

      let!(:managed_order) { create(:order, market: market1, organization_id: 0, items: [create(:order_item, product: product2)]) }
      let!(:org_order)     { create(:order, market: market2, organization_id: 0, items: [create(:order_item, product: product1),create(:order_item, product: product3)]) }
      let!(:not_order)     { create(:order, market: market2, organization_id: 0, items: [create(:order_item, product: product2)]) }

      it "returns only managed markets orders" do
        orders = Order.orders_for_seller(user)

        expect(orders.count).to eq(2)
        expect(orders).to include(managed_order, org_order)
      end
    end

    context "seller" do
      let(:market)       { create(:market) }
      let(:organization) { create(:organization, markets: [market]) }
      let(:product)      { create(:product, :sellable, organization: organization)}
      let(:product2)     { create(:product, :sellable, organization: organization)}
      let!(:user)        { create(:user, organizations:[organization]) }
      let!(:order)       { create(:order, :with_items, organization: organization, market: market) }
      let!(:order_item)  { create(:order_item, order: order, product: product) }
      let!(:order_item2) { create(:order_item, order: order, product: product2) }
      let!(:other_order) { create(:order, :with_items, organization_id: 0, market: market) }

      it 'returns only the organizations orders' do
        orders = Order.orders_for_seller(user)

        expect(orders.count).to eq(1)
        expect(orders).to include(order)
      end
    end
  end

  describe "self.create_from_cart" do
    let(:buyer)             { create(:user) }
    let(:market)            { create(:market, subdomain: "ada") }
    let(:delivery_location) { create(:location) }
    let(:pickup_location)   { create(:market_address, market: market) }
    let(:delivery_schedule) { create(:delivery_schedule) }
    let(:delivery)          { delivery_schedule.next_delivery }
    let(:organization)      { create(:organization, :single_location) }
    let(:billing_address)   { organization.locations.default_billing }
    let(:cart)              { create(:cart, :with_items, organization: organization, delivery: delivery, location: delivery_location, market: market) }
    let(:params)            { { payment_method: "purchase order"} }

    subject { Order.create_from_cart(params, cart, buyer) }

    context "purchase order" do
      let(:params) { { payment_method: "purchase order", payment_note: "1234" } }

      it "sets the payment type" do
        expect(subject.payment_method).to eql("purchase order")
      end

      it "sets the payment note" do
        expect(subject.payment_note).to eql("1234")
      end
    end

    context "when the order is invalid", truncate: true do
      let(:params) { { payment_method: nil, payment_note: "1234" } }

      it "will not consume inventory" do
        expect {
          subject
        }.not_to change{
          cart.items.map{|item| Lot.find_by(product_id: item.product.id).quantity }
        }
      end
    end

    context "when an exception occurs when creating cart items", truncate: true do
      let(:problem_product) { cart.items[1].product }
      subject { expect{ Order.create_from_cart(params, cart, create(:user)) }.to raise_exception }

      before do
        expect(problem_product).to receive(:lots_by_expiration).and_raise
      end

      it "will not create OrderItems" do
        expect {
          subject
        }.not_to change {
          OrderItem.count
        }
      end

      it "will not consume inventory" do
        expect {
          subject
        }.not_to change {
          cart.items.map{|item| Lot.find_by(product_id: item.product.id).quantity }
        }
      end
    end

    it "assigns the cart references" do
      expect(subject.organization).to eql(cart.organization)
      expect(subject.market).to eql(cart.market)
      expect(subject.delivery).to eql(cart.delivery)
    end

    context "delivery information" do
      context "for dropoff" do
        let(:delivery_schedule) { create(:delivery_schedule, :buyer_pickup) }
        it "captures location" do
          expect(subject.delivery_address).to eql(pickup_location.address)
          expect(subject.delivery_city).to eql(pickup_location.city)
          expect(subject.delivery_state).to eql(pickup_location.state)
          expect(subject.delivery_zip).to eql(pickup_location.zip)
          expect(subject.delivery_phone).to eql(pickup_location.phone)
          expect(subject.delivery_status).to eql("pending")
        end
      end

      context "for delivery" do
        it "captures location" do
          expect(subject.delivery_address).to eql(delivery_location.address)
          expect(subject.delivery_city).to eql(delivery_location.city)
          expect(subject.delivery_state).to eql(delivery_location.state)
          expect(subject.delivery_zip).to eql(delivery_location.zip)
          expect(subject.delivery_phone).to eql(delivery_location.phone)
          expect(subject.delivery_status).to eql("pending")
        end
      end
    end

    it "captures billing information" do
      expect(subject.billing_organization_name).to eql(organization.name)
      expect(subject.billing_address).to eql(billing_address.address)
      expect(subject.billing_city).to eql(billing_address.city)
      expect(subject.billing_state).to eql(billing_address.state)
      expect(subject.billing_zip).to eql(billing_address.zip)
      expect(subject.billing_phone).to eql(billing_address.phone)
    end

    it "captures payment information" do
      expect(subject.payment_status).to eql("unpaid")
    end

    it "captures order items" do
      expect(subject.items.count).to eql(cart.items.count)
    end

    # TODO: is this the same as created_at?  REMOVE IT!
    it "captures the placed at time" do
      expect(subject.placed_at).to_not be_nil
    end

    it "captures the delivery fees" do
      expect(subject.delivery_fees).to eql(cart.delivery_fees)
    end

    it "captures the total cost" do
      expect(subject.total_cost).to eql(cart.total)
    end

    it "has an order number sequential to the market" do
      Timecop.freeze(Date.parse("2014-03-01"))
      expect(subject.order_number).to eq("LO-14-ADA-0000001")
      Timecop.return
    end

    it "saves the user" do
      expect(subject.placed_by).to eql(buyer)
    end
  end

  describe "#sellers" do
    context "no order items" do
      it "returns an empty array" do
        order = build(:order)
        expect(order.sellers).to eql([])
      end
    end

    context "with order_items" do
      let(:ada_farms) { create(:organization, :seller) }
      let(:fulton_farms) { create(:organization, :seller) }
      let(:not_included_farms) { create(:organization, :seller) }


      let(:kale) { create(:product, :sellable, organization: ada_farms) }
      let(:bananas) { create(:product, :sellable, organization: ada_farms) }
      let(:peas) { create(:product, :sellable, organization: fulton_farms) }
      let!(:tomatoes) { create(:product, :sellable, organization: not_included_farms) }

      it "returns sellers involved in order" do
        order_items = [
          create(:order_item, product: kale),
          create(:order_item, product: bananas),
          create(:order_item, product: peas)
        ]

        order = create(:order, items: order_items)

        expect(order.sellers.count).to eql(2)
        expect(order.sellers).to include(ada_farms)
        expect(order.sellers).to include(fulton_farms)
        expect(order.sellers).not_to include(not_included_farms)
      end
    end
  end
end
