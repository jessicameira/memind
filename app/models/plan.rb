class Plan < ActiveRecord::Base
  belongs_to :user

  validates :description, presence: true
  validates :answer, presence: true
end