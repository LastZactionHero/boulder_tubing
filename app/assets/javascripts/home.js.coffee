$.get '/river-conditions', (data)->
  $content = $('#content')
  $content.find('.pending-verdict').remove()
  $content.append(data)