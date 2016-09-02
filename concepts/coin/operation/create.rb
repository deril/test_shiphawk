require_relative '../../../models/coin'

class Coin::Create < Trailblazer::Operation
  contract do
    property :denomination
    property :amount

    include Reform::Form::Dry::Validations

    validation :default do
      required(:denomination, &:filled?)
      required(:amount, &:filled?)
    end
  end

  def model!(*)
    Coin.new
  end

  def process(params)
    validate(params) do
      contract.save
    end
  end
end
