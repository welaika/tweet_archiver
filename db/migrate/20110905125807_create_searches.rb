class CreateSearches < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :query

      t.timestamps
    end
  end
end
