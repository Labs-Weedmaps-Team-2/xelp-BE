class CreateBusiness < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.float :latitude
      t.float :longitude
      t.string :photo
      t.integer :zipcode
      t.string :yelp_id
      t.float :rating
      t.string :price
      t.text :hours
      t.string :category
      t.string :phone
      t.string :status
      t.string :website
      t.timestamps
    end
  end
end
