class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :body
      t.integer :from_user
      t.integer :to_user
      t.boolean :read

      t.timestamps
    end
  end
end
