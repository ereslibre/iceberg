class Router < ActiveRecord::Base
  belongs_to :model
  has_many   :permissions
end
