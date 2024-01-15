$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('form.new-answer').on('ajax:success', function(e) {
    let answer = e.detail[0];
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    })

  $('.answers').on('ajax:success', function(e) {
    let rate = e.detail[0];
    $('.rating-answer').text('Rating: ' + rate.rating );
  })
});
