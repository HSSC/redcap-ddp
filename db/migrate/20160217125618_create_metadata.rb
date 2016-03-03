class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.string  :field
      t.string  :label
      t.string  :description
      t.integer :temporal
      t.string  :category
      t.string  :subcategory
      t.string  :identifier
      t.string  :source_tblname
      t.string  :source_code
      t.string  :source_name
      t.integer :source_temporal
      t.string  :source_value
      t.integer :version, :default => 1
      t.timestamps null: false
    end
  end
end
