import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  let path = $(location).attr('pathname').split('/')

  consumer.subscriptions.create({ channel: "AnswersChannel", question: path[2]}, {
    received(data){
      let result = this.createTemplate(data)
      $('.answers').append(result)
    },

  createTemplate(data){
    return `<div(id="answer_${data.answer.id}">
      <p> ${data.answer.body}</p>
      <p> Rating: 0 </p>
    </div>`
      }
  })
})
