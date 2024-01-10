$(document).on('turbolinks:load', function() {
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    let questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.questions').on('ajax:success', function(e) {
    let rate = e.detail[0];
    $('.rating-question').text('Rating: ' + rate.rating );
  })
});
