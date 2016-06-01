ready = ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('tbody').append("<tr><td><a href=/questions/#{question.id}>#{question.title}</a></td> <td>#{question.body}</td><td></td></tr>");

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
