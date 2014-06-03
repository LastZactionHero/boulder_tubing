class RiverConditions
  attr_reader :cfs, :temperature, :condition, :today_high, :today_condition,
    :is_good, :verdict

  def initialize

  end

  def fetch!
    weather_data = CachedData.get_instance
    weather_data.cache_new_data if weather_data.expired?

    assign_conditions!(weather_data)

    @verdict
  end

  private

  def assign_conditions!(weather_data)
    @cfs = weather_data.cfs
    @temperature = weather_data.current_temperature
    @condition = weather_data.current_condition
    @today_high = weather_data.today_high
    @today_condition = weather_data.today_condition
    @is_good = is_condition_good?( @condition ) and is_condition_good?( @today_condition )

    @verdict = ok_to_tube?(@cfs, @temperature, @today_high, @is_good)
    true
  end

  def ok_to_tube?(cfs, temperature, today_high, condition_is_good)
    river_is_good = cfs > 40 && cfs < 300
    temp_is_good = temperature > 85 || today_high > 85

    river_is_good && temp_is_good && condition_is_good
  end

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
