class CreateSearchOrders < ActiveRecord::Migration
  def change
    create_table :search_orders do |t|
      t.integer :total_results
      t.string :status
      t.string :search_type

      t.timestamps
    end
  end
end
