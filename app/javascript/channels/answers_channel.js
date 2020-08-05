import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({
    channel: "AnswersChannel",
    question_id: $('.question').attr('data-question-id')
  }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(answer) {
      // Called when there's incoming data on the websocket for this channel
      console.log ('received', answer);

      $('.answers').append(
          $('<div/>').attr('id', `answer-${answer.id}`).html(answer.body));

      $(`#answer-${answer.id}`).append(
          $('<div/>').attr('id', `votes-answer-${answer.id}`).append(
              $('<a/>').addClass('vote_up').attr({
                'data-type':"json",
                'data-remote':"true",
                'rel':"nofollow",
                'data-method':"post",
                'href':`/answers/${answer.id}/vote_up`}).html('vote up'),

              $('<div/>').attr('id', `rating-answer-${answer.id}`).html(0),

              $('<a/>').addClass('vote_down').attr({
                'data-type':'json',
                'data-remote':'true',
                'rel':'nofollow',
                'data-method':'post',
                'href':`/answers/${answer.id}/vote_down`}).html('vote down')));

      $.each(answer.files, function(i) {
        console.log(`${answer.files[i].url}`);
        console.log(`${answer.files[i].name}`);
        $('<div/>').attr('id', `attachment-${answer.files[i].id}`).append(
            $('<a/>').attr({'href':`${answer.files[i].url}`}).html(`${answer.files[i].name}`)).appendTo(`#answer-${answer.id}`)});

      $.each(answer.links, function(i) {
        console.log(`${answer.links[i].url}`);
        console.log(`${answer.links[i].name}`);
        $('<div/>').attr('id', `link-${answer.links[i].id}`).append(
            $('<a/>').attr({'href':`${answer.links[i].url}`}).html(`${answer.links[i].name}`)).appendTo(`#answer-${answer.id}`)});

      if (gon.user_id === answer.question_author_id) {
          $(`#answer-${answer.id}`).append(
              $('<div/>').attr('id', `votes-answer-${answer.id}`).append(
                  $('<a/>').attr({
                      'data-confirm':"Are you sure?",
                      'data-type':"json",
                      'data-remote':"true",
                      'rel':"nofollow",
                      'data-method':"patch",
                      'href':`/answers/${answer.id}/best`}).html('Best')));
      }
    }
  });
})
