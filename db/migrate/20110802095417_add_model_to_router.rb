class AddModelToRouter < ActiveRecord::Migration
  def self.up
    change_table :routers do |t|
      t.references :model
    end
  end

  def self.down
    remove_column :routers, :model
  end
end
