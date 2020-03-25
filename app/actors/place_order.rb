class PlaceOrder < Actor
  play(CreateOrder, CalculatePrice, GreetUser)
end
