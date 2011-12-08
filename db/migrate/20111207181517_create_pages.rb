class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :html
      t.text :css
      t.text :script

      t.timestamps
    end
  end
end
