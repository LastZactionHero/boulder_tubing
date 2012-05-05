include ActionView::Helpers::SanitizeHelper

class HomeController < ApplicationController
  
  def index
    weather_data = CachedData.get_instance
    weather_data.cache_new_data if weather_data.expired?
    
    @cfs = weather_data.cfs
    @temperature = weather_data.current_temperature
    @condition = weather_data.current_condition
    @today_high = weather_data.today_high
    @today_condition = weather_data.today_condition
    @is_good = is_condition_good?( @condition ) and is_condition_good?( @today_condition )
    @verdict = ( @cfs > 40 and @cfs < 300 and @temperature > 85 or @today_high > 85 and @is_good ) ? "Yes" : "No"        
  end
  
  private
  
  def is_condition_good?( condition )
    good = false
     
    good_conditions = [
      'windy',
      'cloudy',
      'mostly cloudy',
      'partly cloudy',
      'clear',
      'sunny',
      'fair',
      'hot' ]
      
    good_conditions.each do |good_condition|
      good = true if condition.downcase.include?( good_condition )
    end
    
    good
  end
  
end