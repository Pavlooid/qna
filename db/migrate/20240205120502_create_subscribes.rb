class CreateSubscribes < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribes do |t|
      t.belongs_to :user
      t.belongs_to :question

      t.timestamps
    end
  end
end
