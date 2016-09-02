migration 'create coins table' do
  database.create_table :coins do
    primary_key :id
    integer     :denomination
    integer     :amount
  end

  coins = database[:coins]
  coins.insert(denomination: 50, amount: 0)
  coins.insert(denomination: 25, amount: 0)
  coins.insert(denomination: 10, amount: 0)
  coins.insert(denomination: 5, amount: 0)
  coins.insert(denomination: 2, amount: 0)
  coins.insert(denomination: 1, amount: 0)
end