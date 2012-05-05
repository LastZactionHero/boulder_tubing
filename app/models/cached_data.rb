include ActionView::Helpers::SanitizeHelper

class CachedData < ActiveRecord::Base
  
  def self.get_instance
    instance = CachedData.first
    unless instance.present?
      instance = CachedData.create( 
        { 
          :cfs => 0.0, 
          :current_temperature => 0.0,
          :current_condition => 'unknown',
          :today_high => 0.0,
          :today_condition => 'unknown',
          :cache_time => DateTime.now
        } )
    end      
    
    instance
  end
  
  def expired?
    # 5 minute expiration
    ( DateTime.now.to_i - self.cache_time.to_i ) > 5 * 60            
  end
  
  def cache_new_data
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    
    url = "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=BOCOBOCO"
    
    a.get( url ) do |page|
      body = ActionView::Helpers::SanitizeHelper.strip_tags( page.body )
      
      start_parse_str = "Most Recent Value:"
      end_parse_str = "cfs"
      start_posn = body.index( start_parse_str ) + start_parse_str.length
      end_posn = body.index( end_parse_str )
      
      self.cfs = body[ start_posn, end_posn - start_posn ].to_f
        
      weather_client = Weatherman::Client.new( { :unit => "f" } )
      weather_response = weather_client.lookup_by_woeid 2367231
      
      self.current_temperature = weather_response.condition['temp']
      self.current_condition = weather_response.condition['text']
      self.today_high = weather_response.forecasts[0]['high']
      self.today_condition = weather_response.forecasts[0]['text']      
    end
    
    self.cache_time = DateTime.now
    self.save
  end
  
end