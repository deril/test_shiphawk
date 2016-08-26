require 'rom-repository'
require_relative '../mappers/coin'

module Repository
  class Coin < ROM::Repository[:coins]
    commands :create, update: :by_denomination, delete: :by_denomination

    def all
      processor = Mappers::Coin.build
      processor.call(coins)
    end
  end
end
