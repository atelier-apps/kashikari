class AddNoteToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :note, :text
  end
end
