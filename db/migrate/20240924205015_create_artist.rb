class CreateArtist < ActiveRecord::Migration[7.2]
  def change
    create_table :artists do |t|
      t.timestamps
    end
  end
end
