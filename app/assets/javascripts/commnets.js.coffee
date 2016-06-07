ready = ->
  PrivatePub.subscribe '/comments', (data, channel) ->
    comment_author = $.parseJSON(data['comment_author'])
    comment_body = $.parseJSON(data['comment']).body
    commentable_id = $.parseJSON(data['comment']).commentable_id
    commentable_type = $.parseJSON(data['comment']).commentable_type
    created_at = $.parseJSON(data['created_at'])

    $( '.' + commentable_type + '-comments#' + commentable_id).append(
      JST["templates/comment"]({comment_author: comment_author, comment: comment_body, created_at: created_at})
    )
    $('textarea#comment_body').val('')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
