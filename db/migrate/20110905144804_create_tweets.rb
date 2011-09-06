class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :from_user
      t.string :profile_image_url
      t.text :text
      t.datetime :posted_at
      t.references :subscription

      t.timestamps
    end
    add_index :tweets, :subscription_id
  end
end
