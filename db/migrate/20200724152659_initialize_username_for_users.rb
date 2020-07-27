class InitializeUsernameForUsers < ActiveRecord::Migration[5.2]
  def change
    User.all.each {|u| u.update(username: u.email)}
  end
end
