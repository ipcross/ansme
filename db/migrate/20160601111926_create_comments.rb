class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commentable_id
      t.string :commentable_type
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
