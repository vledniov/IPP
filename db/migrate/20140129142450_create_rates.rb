class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.date    :made_on,       null: false
      t.string  :currency_code, null: false
      t.decimal :value,         null: false

      t.timestamps
    end
  end
end
