class CreateSmallUrlsTable < ActiveRecord::Migration[5.1]
  def change
    create_table(:small_urls_tables) do |t|
      t.timestamps
      t.text :original_url, null: :no
      t.integer :visit_count, null: :no, default: 0
    end
  end
end
