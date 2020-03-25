class PlaceOrder < Actor
  play(CreateOrder)
  play CalculatePrice, if: ->(result) {result.success?}
  play(GreetUser)
end
