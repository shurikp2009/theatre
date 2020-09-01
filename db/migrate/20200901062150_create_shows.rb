class CreateShows < ActiveRecord::Migration[6.0]
  def change
    create_table :shows do |t|
      t.string :title
      t.date :date_from
      t.date :date_to

      t.timestamps
    end
  end
end
