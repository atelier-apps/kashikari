class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.bigint :contract_id
      t.integer :amount

      t.timestamps
    end
  end
end
