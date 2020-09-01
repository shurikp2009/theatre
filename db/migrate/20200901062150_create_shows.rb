class CreateShows < ActiveRecord::Migration[6.0]
  def change
    create_table :shows do |t|
      t.string :title, index: true
      t.daterange :period, index: { using: 'gist' }

      t.timestamps
    end
  end
end
