class CreateMathmathSpecialNumbers < ActiveRecord::Migration
  def change
    create_table :mathmath_special_numbers do |t|
      t.string :name
      t.string :description
      t.decimal :value

      t.timestamps
    end
  end
end
