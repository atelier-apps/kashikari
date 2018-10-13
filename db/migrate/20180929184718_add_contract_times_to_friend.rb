class AddContractTimesToFriend < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :contract_times, :integer, default: 0
  end
end
