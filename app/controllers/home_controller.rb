include ActionView::Helpers::SanitizeHelper

class HomeController < ApplicationController

  def index
    @conditions = RiverConditions.new
    @conditions.fetch!
  end

end
