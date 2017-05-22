class CreateOwnersAndSmallUrlsTables < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table(:owners) do |t|
      t.uuid :external_identifier, null: false, unique: true
    end
    
    create_table(:small_urls) do |t|
      t.timestamps
      t.text :original_url, null: :no
      t.integer :visit_count, null: :no, default: 0
      t.integer :owner_id, references: [:owners]
      t.boolean :disabled, null: :no, default: false
      t.uuid :public_identifier, null: :false, default: 'uuid_generate_v4()'
    end
  end
  
  def down
    drop_table(:small_urls)
    drop_table(:owners)
  end
end
