module RiverConditionsHelper

  def verdict_text(verdict)
    verdict ? "Yes" : "No"
  end

  def verdict_class(verdict)
    verdict ? "yes" : "no"
  end

  def river_description(cfs)
    if cfs < 40 # TODO convert to case statement
      "Not enough water for tubing"
    elsif cfs >= 40 and cfs < 100
      "Enough water for a mellow tubing day"
    elsif cfs >= 100 and cfs < 200
      "Perfect tubing conditions"
    elsif cfs >= 200 and cfs < 300
      "Fairly fast moving water- you will likely flip"
    else
      "Very fast moving water"
    end
  end

  def weather_description(temp_current, temp_high, good_weather_condition)
    if temp_current < 85 and temp_high < 85
      "Too cold"
    elsif !good_weather_condition
      "Weather seems bad"
    else
      "Looks good"
    end
  end

end
