class GreetUser < Actor
  input :user
  input :adjective, type: String,
                    must: {
                      be_longer_than_4_characters: ->(adjective) { adjective.length > 4}
                    }
                    # default: ->{ ["yummy", "delicous"].sample }

  output :message
  def call
    self.message = "Have a #{adjective} meal, #{user.name}"
  end
end
