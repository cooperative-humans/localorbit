class OrdersController < ApplicationController
  before_action :require_cart
  before_action :hide_admin_navigation

  def create
    @placed_order = PlaceOrder.perform(buyer: current_user, order_params: order_params, cart: current_cart)

    if @placed_order.context.has_key?(:order)
      @order = @placed_order.order.decorate
    end

    if @placed_order.success?
      session.delete(:cart_id)
    else
      @grouped_items = current_cart.items.for_checkout

      if @placed_order.context.has_key?(:cart_is_empty)
        redirect_to [:products], alert: @placed_order.message
      else
        flash.now[:alert] = "Your order could not be completed."
        render "carts/show"
      end
    end
  end

  protected

  def order_params
    params.require(:order).permit(:payment_method, :payment_note, :credit_card)
  end
end
