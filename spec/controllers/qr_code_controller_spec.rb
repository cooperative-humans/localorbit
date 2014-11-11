describe QrCodeController do
  include_context "the mini market" 

  let!(:product1) { create(:product, :sellable, organization: seller_organization) }
  let!(:order_item1) { create(:order_item, product: product1) }
  let!(:order) { create(:order, items: [order_item1], market: mini_market, organization: buyer_organization) }

  describe "#order" do
    context "logged in as a buyer" do
      before do
        switch_to_subdomain mini_market.subdomain
        sign_in barry
        switch_to_subdomain "app"
      end
      it "redirects to the correct order url on the correct subdomain" do
        get :order, id: order.id
        host = "http://#{order.market.subdomain}.localtest.me"
        expect(response).to redirect_to(order_url(host: host, id: order.id))
      end
    end

    context "logged in as a seller" do
      before do
        switch_to_subdomain mini_market.subdomain
        sign_in sally
        switch_to_subdomain "app"
      end
      it "redirects to the correct order url on the correct subdomain" do
        get :order, id: order.id
        host = "http://#{order.market.subdomain}.localtest.me"
        expect(response).to redirect_to(admin_order_url(host: host, id: order.id))
      end
    end

    context "logged in as a market manager" do
      before do
        switch_to_subdomain mini_market.subdomain
        sign_in mary
        switch_to_subdomain "app"
      end
      it "redirects to the correct order url on the correct subdomain" do
        get :order, id: order.id
        host = "http://#{order.market.subdomain}.localtest.me"
        expect(response).to redirect_to(admin_order_url(host: host, id: order.id))
      end
    end

    context "logged in as an admin" do
      before do
        switch_to_subdomain mini_market.subdomain
        sign_in aaron
        switch_to_subdomain "app"
      end

      it "redirects to the correct order url on the correct subdomain" do
        get :order, id: order.id
        host = "http://#{order.market.subdomain}.localtest.me"
        expect(response).to redirect_to(admin_order_url(host: host, id: order.id))
      end
    end
  end
end

