class RenameCommandToCommandLine < ActiveRecord::Migration
  def self.up
    rename_column :command_sets, :command, :command_line
  end

  def self.down
    rename_column :command_sets, :command_line, :command
  end
end
