class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :photo, :default => "https://avatars1.githubusercontent.com/u/20796852?s=400&v=4"

      t.timestamps
    end
  end
end
