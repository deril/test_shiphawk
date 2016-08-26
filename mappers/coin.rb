require 'rom-mapper'

module Mappers
  class Coin < ROM::Mapper
    symbolize_keys true

    attribute :denominator
    attribute :amount
    exclude :id
  end
end
