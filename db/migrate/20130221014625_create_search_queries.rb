class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.integer :search_order_id
      t.string :content
      t.string :status

      t.timestamps
    end
  end
end
