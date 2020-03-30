class OrdersController < ApplicationController
  def create
    result = PlaceOrder.result(user: User.first, meal: Meal.first, order: Order.new)
    if result.success?
      redirect_to result.order
    else
      render :new, notice: result.error
    end
  end
end
