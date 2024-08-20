class CreatePlan < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
      t.string :description
      t.string :answer

      t.timestamps
    end
  end
end
