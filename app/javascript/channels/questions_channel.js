import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected to questions chanel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(question) {
    // Called when there's incoming data on the websocket for this channel
    console.log ('received', question);
    // console.log ('received', gon.user_id);
    $('.questions').append(
          $('<div/>').attr('id', `question-${question.id}`).html(question.title)
    );

    $(`#question-${question.id}`).append(
        $('<div/>').attr('id', `votes-question-${question.id}`).append(
            $('<a/>').addClass('vote_up').attr({
                'data-type':"json",
                'data-remote':"true",
                'rel':"nofollow",
                'data-method':"post",
                'href':`/questions/${question.id}/vote_up`}).html('vote up'),

            $('<div/>').attr('id', `rating-question-${question.id}`).html(0),

            $('<a/>').addClass('vote_down').attr({
              'data-type':'json',
              'data-remote':'true',
              'rel':'nofollow',
              'data-method':'post',
              'href':`/questions/${question.id}/vote_down`}).html('vote down')));

    $.each(question.award, function(i) {
        console.log(`<img src=${question.award[i].url} height="40px"`);
        $('<div/>').attr('id', `award-${question.id}`).html(
            (`<img src=${question.award[i].url} height="40px">`)).appendTo(`#question-${question.id}`)});

    $.each(question.files, function(i) {
        console.log(`${question.files[i].url}`);
        console.log(`${question.files[i].name}`);
        $('<div/>').attr('id', `attachment-${question.files[i].id}`).append(
            $('<a/>').attr({'href':`${question.files[i].url}`}).html(`${question.files[i].name}`)).appendTo(`#question-${question.id}`)});

    $.each(question.links, function(i) {
        console.log(`${question.links[i].url}`);
        console.log(`${question.links[i].name}`);
        $('<div/>').attr('id', `link-${question.links[i].id}`).append(
            $('<a/>').attr({'href':`${question.links[i].url}`}).html(`${question.links[i].name}`)).appendTo(`#question-${question.id}`)});

    $(`#question-${question.id}`).append(
        $('<a/>').attr({'href':`/questions/${question.id}/`}).html('Answers'))

  }
});
