class AddMaxSessionsToRouter < ActiveRecord::Migration
  def self.up
    add_column :routers, :max_sessions, :integer
  end

  def self.down
    remove_column :routers, :max_sessions
  end
end
