$(document).on('turbolinks:load', function(){
  console.log('r');
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  })
});
