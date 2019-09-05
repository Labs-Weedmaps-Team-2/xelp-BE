class CreateUserLogin < ActiveRecord::Migration[5.2]
  def change
    create_table :user_logins do |t|
      t.references :user, foreign_key: true
      
    end
  end
end
