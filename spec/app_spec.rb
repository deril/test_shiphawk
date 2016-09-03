require File.expand_path '../spec_helper.rb', __FILE__

describe 'My Sinatra Application' do
  let(:default_state) {
    {
      50 => 0,
      25 => 0,
      10 => 0,
      5  => 0,
      2  => 0,
      1  => 0
    }
  }

  subject { last_response.body }

  describe 'GET /machine' do

    before { get '/machine' }

    it { is_expected.to include_json(default_state) }
  end

  describe 'POST /machine' do
    before { post '/machine', post_params }

    context 'with valid params' do
      let(:post_params) {
        Oj.dump(
          {
            50 => 3,
            25 => 4
          }
        )
      }

      it { is_expected.to include_json(status: true) }
    end

    context 'with wrong params' do
      let(:post_params) {
        Oj.dump(
          {
            50 => nil,
            25 => 4
          }
        )
      }

      it { is_expected.to include_json(status: false) }
    end
  end


  describe 'PUT /machine' do
    before { put '/machine', put_params }

    context 'with valid params' do
      let(:put_params) {
        Oj.dump(
          {
            50 => 8,
            25 => 4
          }
        )
      }

      it { is_expected.to include_json(status: true) }

      it 'returns new state' do
        get '/machine'
        expect(subject).to include_json(default_state.merge(Oj.load(put_params)))
      end
    end

    context 'with wrong params' do
      let(:put_params) {
        Oj.dump(
          {
            50 => nil,
            25 => 4
          }
        )
      }

      it { is_expected.to include_json(status: false) }
    end
  end

  describe 'POST /machine/change' do
    let(:post_params) { Oj.dump({amount: amount}) }
    before do
      set_values
      post '/machine/change', post_params
    end

    context 'when enough money' do
      let(:amount) { 200 }
      let(:set_values) do
        Coin[denomination: 50].update(amount: 3)
        Coin[denomination: 25].update(amount: 4)
      end

      it { is_expected.to include_json(50 => 3, 25 => 2) }

      it 'updates amount' do
        get '/machine'
        expect(subject).to include_json(default_state.merge(25 => 2))
      end
    end

    context 'when wrong amount' do
      let(:amount) { 'abc' }
      let(:set_values) do
        Coin[denomination: 50].update(amount: 3)
        Coin[denomination: 25].update(amount: 4)
      end

      it { is_expected.to include_json(error: 'Wrong amount of money') }
    end

    context 'when no money in the machine' do
      let(:amount) { 200 }
      let(:set_values) {}
      it { is_expected.to include_json(error: 'Not enough money in the machine') }
    end

    context 'when cannot get change' do
      let(:amount) { 153 }
      let(:set_values) do
        Coin[denomination: 50].update(amount: 3)
        Coin[denomination: 25].update(amount: 4)
      end

      it { is_expected.to include_json(error: 'Cannot get change') }
    end
  end
end



# require File.dirname(__FILE__) + '/spec_helper'
#
# describe 'App' do
#   include Rack::Test::Methods
#
#   def app
#     @app ||= Sinatra::Application
#   end
#
#   describe 'get /machine' do
#     it 'returns current state' do
#       get '/'
#       expect(last_response).to be_ok
#       expect(last_response.body).to match '{}'
#     end
#   end
# end