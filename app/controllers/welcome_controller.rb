class WelcomeController < ApplicationController
  def index
    @routers = Router.all
    @commands = Command.all
  end
end
