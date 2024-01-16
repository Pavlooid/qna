import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  let path = $(location).attr('pathname').split('/')

  consumer.subscriptions.create({ channel: 'CommentsChannel' }, {
    connected: function(){
      return this.perform('follow', {question_id: path[2] })
    },

    received(data){
      $('.comments-'+ data.comment.commentable_id).append('<p>' + data.comment.body + '</p>')
    }
  })
})