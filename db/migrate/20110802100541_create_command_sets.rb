class CreateCommandSets < ActiveRecord::Migration
  def self.up
    create_table :command_sets do |t|
      t.references :command
      t.references :model
      t.string :command

      t.timestamps
    end
  end

  def self.down
    drop_table :command_sets
  end
end
