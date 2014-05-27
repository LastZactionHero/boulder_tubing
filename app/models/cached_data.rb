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
    ( DateTime.now.to_i - self.cache_time.to_i ) > 5 * 60 || self.cfs <= 0.0
  end

  def cache_new_data
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    url = "http://waterdata.usgs.gov/co/nwis/uv/?site_no=06730200"

    a.get( url ) do |page|
      body = page.body
      self.cfs = body.scan(/00060:[0-9]+:[0-9]+/).first.split(":")[1].to_f
      
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
