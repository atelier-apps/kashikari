class AddPasscodeToContracts < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :passcode, :string
  end
end
