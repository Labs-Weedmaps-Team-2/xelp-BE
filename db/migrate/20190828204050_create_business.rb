class CreateBusiness < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :photo
      t.string :phone
      t.string :coords
    end
  end
end
