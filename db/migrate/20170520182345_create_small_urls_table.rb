class CreateSmallUrlsTable < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    
    create_table(:small_urls) do |t|
      t.timestamps
      t.text :original_url, null: :no
      t.integer :visit_count, null: :no, default: 0
      t.uuid :owner_identifier, null: false
    end
  end
  
  def down
    drop_table(:small_urls)
  end
end
