include ActionView::Helpers::SanitizeHelper

class HomeController < ApplicationController
  
  def index
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    
    url = "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BOCOBOCO"
    
    a.get( url ) do |page|
      @body = ActionView::Helpers::SanitizeHelper.strip_tags( page.body )
      
      start_parse_str = "Most Recent Value:"
      end_parse_str = "cfs"
      start_posn = @body.index( start_parse_str ) + start_parse_str.length
      end_posn = @body.index( end_parse_str )
      
      @cfs = @body[ start_posn, end_posn - start_posn ].to_f
        
      weather_client = Weatherman::Client.new( { :unit => "f" } )
      @weather_response = weather_client.lookup_by_woeid 2367231
      
      @temperature = @weather_response.condition['temp']
      @condition = @weather_response.condition['text']
      @today_high = @weather_response.forecasts[0]['high']
      @today_condition = @weather_response.forecasts[0]['text']
      @is_good = is_condition_good?( @condition ) and is_condition_good?( @today_condition )
      @verdict = ( @cfs > 40 and @cfs < 300 and @temperature > 85 or @today_high > 85 and @is_good ) ? "Yes" : "No"
    end        
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