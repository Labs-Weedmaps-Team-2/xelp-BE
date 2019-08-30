class CreateBusiness < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :latitude
      t.string :longitude
      t.string :photo
    end
  end
end
