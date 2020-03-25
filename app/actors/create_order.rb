# frozen_string_literal: true

class CreateOrder < Actor
  input :order, type: Order
  input :user, type: User, allow_nil: true
  input :meal, type: Meal

  def call
    order.meal = meal
    order.user = user
    order.status = "Order Created"
    order.delivery_fee = 2.0
    fail!(error: 'Invalid Order') unless order.valid?

    order.save
  end

  def rollback
    order.destroy
  end
end
