# frozen_string_literal: true

class UserMessage < Actor
  input :word, type: String,
               must: {
                be_longer_than_4_characters: ->(word) { word.length > 4}
               },
               default: -> { ["wonderful", "great"].sample }

  output :message
  def call
    self.message = "Have a #{word} day!"
  end
end
