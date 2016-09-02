require 'sinatra'
require 'sinatra/contrib'
require 'oj'
require_relative 'config/init'

require 'pry'

before do
  request.body.rewind
  @request_payload = Oj.load(request.body.read)
end

post '/machine' do
  results = @request_payload.map do |denomination, amount|
    Coin::Create.run(denomination: denomination, amount: amount).first
  end

  json results.all?
end

put '/machine' do
  results = @request_payload.map do |denomination, amount|
    Coin::Update.run(denomination: denomination, amount: amount).first
  end

  json results.all?
end

get '/machine' do
  op = Coin.to_hash(:denomination, :amount)
  json op
end

post '/machine/change' do
  op = Coin::Change.run(@request_payload)
  json op.last.result
end
