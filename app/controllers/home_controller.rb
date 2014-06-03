include ActionView::Helpers::SanitizeHelper

class HomeController < ApplicationController

  def index
    @river_conditions = RiverConditions.new
    @river_conditions.fetch!
  end

end
