class RiverConditionsController < ApplicationController

  def index
    @conditions = RiverConditions.new
    @conditions.fetch!
    render layout: false
  end

end
