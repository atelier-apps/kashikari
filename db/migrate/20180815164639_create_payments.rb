class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.text :contractId
      t.integer :amount
      t.text :status

      t.timestamps
    end
  end
end
