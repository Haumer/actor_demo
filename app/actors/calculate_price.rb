# frozen_string_literal: true

class CalculatePrice < Actor
  input :meal
  input :order

  output :price
  def call
    self.price = meal.price + order.delivery_fee
  end

  def rollback

  end
end
