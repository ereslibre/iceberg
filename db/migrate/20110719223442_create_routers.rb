class CreateRouters < ActiveRecord::Migration
  def self.up
    create_table :routers do |t|
      t.string :name
      t.string :comment
      t.string :password
      t.string :server
      t.integer :port
      t.string :router_username
      t.string :router_password

      t.timestamps
    end
  end

  def self.down
    drop_table :routers
  end
end
