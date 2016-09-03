require_relative '../../../models/coin'
require_relative 'update'

class Coin::Change < Trailblazer::Operation
  attr_reader :result

  def process(params)
    value = validate(params.fetch(:amount, 0).to_i)

    @result = if wrong_value(value)
      value
    else
      change = get_change(value, available_coins)

      unless wrong_value(change)
        available_coins.map do |denomination, amount|
          Coin::Update.run(denomination: denomination, amount: amount).first
        end
      end

      change
    end
  end

  private

  def get_change(value, coins, res = [])
    denomination, _ = coins.find { |denomination, amount| value >= denomination && amount > 0 }
    return {error: 'Cannot get change'} unless denomination

    value -= denomination
    coins[denomination] -= 1
    res << denomination

    if value > 0
      get_change(value, coins, res)
    else
      res.inject(Hash.new(0)) { |hash, el| hash[el] += 1; hash }
    end
  end

  def validate(value)
    return {error: 'Wrong amount of money'} unless value > 0

    all_money = available_coins.inject(0) { |res, coins| res + (coins[0] * coins[1]) }
    return {error: 'Not enough money in the machine'} if value > all_money

    value
  end

  def available_coins
    @available_coins ||= Coin.to_hash(:denomination, :amount).sort.reverse.to_h
  end

  def wrong_value(value)
    value.is_a?(Hash) && value.key?(:error)
  end
end
