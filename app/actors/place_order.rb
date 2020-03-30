# frozen_string_literal: true

class PlaceOrder < Actor
  play(CreateOrder)
  play UserMessage, if: ->(result) {result.meal.price > 100 }
end
