class CreateUsersTable < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    
    create_table :users do |t|
      t.timestamps
      t.uuid :public_identifier, null: :false, default: 'uuid_generate_v4()'
      t.text :username, null: :no
      t.text :password, null: :no
      t.text :salt, null: :no
    end
  end

  def down
    drop_table(:users)
  end
end
