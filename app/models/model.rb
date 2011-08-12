class Model < ActiveRecord::Base
  has_many :routers
  has_many :command_sets
end