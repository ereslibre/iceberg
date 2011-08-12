class StepController < ApplicationController
  def show
    @step_id = params[:id].to_i
  end
end
