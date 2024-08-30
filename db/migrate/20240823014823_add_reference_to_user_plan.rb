class AddReferenceToUserPlan < ActiveRecord::Migration[7.1]
  def change
    add_reference :plans, :user, null: false, foreign_key: true
  end
end
