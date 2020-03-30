# frozen_string_literal: true

class CreateOrder < Actor
  input :order, type: Order
  input :user, type: User, allow_nil: true
  input :meal

  def call
    order.meal = meal
    order.user = user
    order.status = "Order Created"
    fail!(error: "Invalid Order") unless order.valid?
    order.save
  end
end
