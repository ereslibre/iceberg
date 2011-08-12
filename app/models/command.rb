class Command < ActiveRecord::Base
  has_many :permissions
  has_many :command_sets
end