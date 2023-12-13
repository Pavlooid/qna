$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    console.log(123)
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

});
