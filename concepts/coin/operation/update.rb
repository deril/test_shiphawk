require_relative 'create'

class Coin::Update < Coin::Create
  def model!(params)
    Coin[denomination: params[:denomination]]
  end
end
