# Service Actor Tutorial

**[github repo](https://github.com/sunny/actor)**

### Setup:

Gemfile
```
gem 'service_actor'
gem 'service_actor-rails'
```

Generate Actor files with:
```
rails g actor NameOfActor
#=> app/actors/name_of_actor.rb
```

### Create your first actor:

With the Generator:
```sh
rails g actor MessageUser
```
```
# app/actors/message_user.rb
class UserMessage < Actor
    def call
    end
end
```

Lets add an input and customise the .call:
```sh
class UserMessage < Actor
    input :word

    def call
        puts "Have a #{word} meal!"
    end
end
```

Inside a rails console:
```
UserMessage.call(word: "nice")
#=> Have a nice meal!
```

.call returns a result hash

### Expanding your Actor
Lets add output:
```sh
class UserMessage < Actor
    input :word
    output :message

    def call
        self.message = "Have a #{word} meal!"
    end
end

result = UserMessage.call(word: "nice")
result.message
#=> Have a nice meal!
```
in essence the message output was added to the results hash

#### Input validation
specify the input type, for example
```
    input :word, type: String, allow_nil: true
    input :number, type: [Integer, Float]
    input :user, type: User
```
simple validation:
```
    input :word, must: {
                    be_longer_than_4_characters: ->(word) { word.length > 4}
                 }
```
add a default:
```
    input :word, default: -> { "nice" }
    input :number, default: -> { [1,2,3].sample }
    input :user, default: -> { User.find(1) }
```

### Working example:
##### Food delivery
**Models** for _User_, _Meal_ and _Order_

Custom message for our User:
```
class UserMessage < Actor
    input :word, type: String,
                 must: {
                    be_longer_than_4_characters: ->(word) { word.length > 4}
                },
                default: -> { ["wonderful", "great"].sample }
    output :message
    def call
        self.message = "Have a #{word} Meal!"
    end
end
```

Second Actor for the creation of a new order:
```
class CreateOrder < Actor
    input :order, type: Order
    input :user, type: User, allow_nil: true
    input :meal

    def call
        order.meal = meal
        order.user = user
        order.status = "Order Created"
        order.save
    end
end
```

Create a custom error if the order is invalid:
```
class CreateOrder < Actor
    (...)
    def call
        (...)
        fail!(error: "Invalid Order") unless order.valid?
        order.save
    end
end
```

```
CreateOrder.call(order: Order.new, meal: Meal.first, user: nil)
#=> ServiceActor::Failure: Invalid Order
```

### Actors participate in a play
Third Actor, who calls the play method:
```
class PlaceOrder < Actor
    play(CreateOrder, UserMessage)
end

result = PlaceOrder.call(order: Order.new, meal: Meal.first, user: User.first)
result.success?
#=> true # if no error
result.failure?
#=> true # if error
result.error
#=> <custom error> # if error
#=> nil # if no error
```

**Note** through the results hash you have access to all inputs and outputs of all actors, meaning result.order, result.meal and result.user all retrieve the instances used in the play!

### Apply in your controller
In our Orders controller we could place:
```
def create
    result = PlaceOrder.result(user: User.first, meal: Meal.first, order: Order.new)
    if result.success?
        redirect_to result.order
    else
        render :new, notice: result.error
    end
end
```
**Note** we call .result here in order to retrieve the result hash!

Voila, you have exported some of the clutter out of your controller!

you can find a working repo [here](https://github.com/Haumer/actor_demo)
