class CreateCarritos < ActiveRecord::Migration[7.1]
  def change
    create_table :carritos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :producto, null: false, foreign_key: true
      t.integer :cantidad

      t.timestamps
    end

    add_index :carritos, [:user_id, :producto_id], unique: true
  end
end
