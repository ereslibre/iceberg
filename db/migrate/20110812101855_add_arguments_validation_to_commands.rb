class AddArgumentsValidationToCommands < ActiveRecord::Migration
  def self.up
    add_column :commands, :arguments_validation, :string
  end

  def self.down
    remove_column :commands, :arguments_validation
  end
end
