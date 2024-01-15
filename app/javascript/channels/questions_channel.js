import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  consumer.subscriptions.create({ channel: 'QuestionsChannel' }, {
    received(data){
      let result = this.createTemplate(data.question)
      $('.questions').append(result)
    },

    createTemplate(question){
      return `<div(id="question_#{question.id}")>
        <a title = ${question.title} href = 'questions/${question.id}'>${question.title}</a><br>
        <a>${question.body}</a>
      </div>`
    }
  })
})