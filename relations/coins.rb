require 'rom-sql'
require 'rom-repository'

module Relations
  class Coins < ROM::Relation[:sql]
    schema(:coins) do
      attribute :id, Types::Serial
      attribute :denomination, Types::String
      attribute :amount, Types::Int
    end
  end
end
