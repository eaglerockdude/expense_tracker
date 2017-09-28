require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

# define our classes here for illustration purposes
    def app
      ExpenseTracker::API.new
    end
    it 'captures/records submitted expenses' do
      coffee = {
          'payee' => 'starbucks',
          'amount' => '5.75',
          'date' => '2017-09-18'
      }
      post 'expenses', JSON.generate(coffee)
      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end
  end
end