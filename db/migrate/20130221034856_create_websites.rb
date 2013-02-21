class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.integer :search_order_id
      t.string :domain_name

      t.timestamps
    end
  end
end
