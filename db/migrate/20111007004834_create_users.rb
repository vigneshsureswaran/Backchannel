class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :username
      t.string :password
      t.string :role, :default=> "User"

      t.timestamps
    end
  end
end
