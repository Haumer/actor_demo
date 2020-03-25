class OrdersController < ApplicationController
  def create
    result = PlaceOrder.call(order: Order.new, meal: Meal.first, user: User.first)

    if result.success?
      redirect_to result.order
    else
      render :new, notice: result.error
    end
  end
end
