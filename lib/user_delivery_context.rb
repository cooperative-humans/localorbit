require 'constructor_struct'
UserDeliveryContext = ConstructorStruct.new(
    :available_features,
    :is_market_manager,
    :is_seller,
    :is_buyer_only,
    :is_admin) do

  def has_feature(sym)
    available_features.include?(sym)
  end

  def self.build_delivery_context(user:, delivery:)
    delivery_market = delivery.delivery_schedule.market
    available_features = delivery_market.plan.attributes.map{|attribute, value| attribute.to_sym if value == true}.compact
    is_market_manager = user.managed_markets.include?(delivery_market)
    is_seller = false
    delivery.orders.each do |order|
      order.items.each{|item| is_seller = true if user.organizations.include?(item.seller)}
    end
    is_buyer_only = (user.buyer_only?)
    is_admin = user.admin?

    return self.new(
      available_features: available_features, 
      is_market_manager: is_market_manager, 
      is_seller: is_seller, 
      is_buyer_only: is_buyer_only, 
      is_admin: is_admin
    )
  end
end
