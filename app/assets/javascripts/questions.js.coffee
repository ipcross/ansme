ready = ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    current_user = $.parseJSON(data['current_user'])
    $('tbody').append(JST["templates/question"]({question: question, current_user: current_user}));

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
