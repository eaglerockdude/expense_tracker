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
# expense generating method
    def post_expense(expense)
      post 'expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
        expense.merge('id' => parsed['expense_id'])
    end
    
    it 'captures/records submitted expenses' do
      pending 'need to implement saving or persisting our expenses'
      # create some expense data for tests
      coffee = post_expense(
          'payee' => 'Starbucks',
          'amount' => '5.75',
          'date' => '2017-09-18'
      )
      zoo = post_expense(
          'payee' => 'Zoo',
          'amount' => 15.25,
          'date' => '2017-09-18'
      )
      groceries = post_expense(
          'payee' => 'Whole Foods',
          'amount' => 95.20,
          'date' => '2017-09-25'
      )

      get '/expenses/2017-09-18'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end