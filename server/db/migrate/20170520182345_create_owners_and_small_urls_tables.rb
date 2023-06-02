class CreateOwnersAndSmallUrlsTables < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table(:owners) do |t|
      t.uuid :external_identifier, null: false, unique: true
    end
    
    create_table(:small_urls) do |t|
      t.timestamps
      t.uuid :public_identifier, null: :false, default: 'uuid_generate_v4()'
      t.text :encrypted_url, null: :no
      t.text :salt, null: :no
      t.integer :owner_id, references: [:owners]
      t.integer :visit_count, null: :no, default: 0
      t.boolean :disabled, null: :no, default: false
    end
  end
  
  def down
    drop_table(:small_urls)
    drop_table(:owners)
  end
end
