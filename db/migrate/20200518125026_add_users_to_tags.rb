class AddUsersToTags < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :user, foreign_key: true
  end
end
