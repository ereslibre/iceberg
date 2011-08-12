class CommandSet < ActiveRecord::Base
  belongs_to :command
  belongs_to :model
end