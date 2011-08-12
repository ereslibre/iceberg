class Permission < ActiveRecord::Base
  belongs_to :router
  belongs_to :command
end