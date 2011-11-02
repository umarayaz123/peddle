class CreateSysAdmins < ActiveRecord::Migration
  def change
    create_table :sys_admins do |t|
      t.string :name

      t.timestamps
    end
  end
end
