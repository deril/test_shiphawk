require 'sinatra'
require 'sinatra/json'
require_relative 'relations/coins'
require_relative 'repositories/coin'

DEFAULT_DENOMINATORS = %w(1 2 5 10 25 50)

config = ROM::Configuration.new(:sql, "sqlite://db/sqlite.db")
config.register_relation Relations::Coins
container = ROM.container(config)

container.gateways[:default].tap do |gateway|
  migration = gateway.migration do
    change do
      create_table :coins do
        primary_key :id
        column :denomination, String, null: false, uniq: true
        column :amount, Integer
      end
    end
  end
  unless gateway.dataset?(:coins)
    migration.apply gateway.connection, :up
    DEFAULT_DENOMINATORS.each do |denom|
      gateway.dataset(:coins).insert(denomination: denom)
    end
  end
end

get '/machine' do
  coin_repo = Repository::Coin.new(container)
  json coin_repo.all
end

post '/machine' do

end

put '/machine' do

end
