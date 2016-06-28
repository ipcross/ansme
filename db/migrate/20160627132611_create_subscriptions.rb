class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :question_id

      t.timestamps null: false
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :question_id
  end
end
