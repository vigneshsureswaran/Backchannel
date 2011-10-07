class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :post
      t.integer :post_id, :default=> 0
      t.float :weight
      t.references :user

      t.timestamps
    end
  end
end
