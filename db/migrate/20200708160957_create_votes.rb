class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :vote, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false
      t.index [ :votable_type, :votable_id, :user_id ], name: "index_user_vote_per_resource_uniqueness", unique: true

      t.timestamps
    end
  end
end
