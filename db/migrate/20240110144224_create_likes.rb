class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :rating, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :likeable, polymorphic: true

      t.timestamps
    end
  end
end
