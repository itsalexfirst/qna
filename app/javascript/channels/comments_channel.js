import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({
    channel: "CommentsChannel",
    question_id: $('.question').attr('data-question-id')
  }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(comment) {
    console.log(comment)
    var commentableType = comment.commentable_type.toLowerCase();
    var commentableId = comment.commentable_id;

    console.log(`#${commentableType}-${commentableId}-comments-${comment.id}`)

    $(`#${commentableType}-${commentableId}-comments`).append(
        $('<div/>').attr('id', `comment-${comment.id}`).html(comment.body));

    $('.add-comment').show();

    $(`form#${commentableType}-${commentableId}-comments`).hide();
  }
 });
})
