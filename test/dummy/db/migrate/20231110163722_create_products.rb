class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :code
      t.integer :status
      t.references :lato_user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
