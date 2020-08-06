$(document).on('turbolinks:load', function(){
    $(document).on('ajax:success', '.vote_up, .vote_down', function(e) {
        e.preventDefault();
        var voteDetail = e.detail[0];

        resName = voteDetail.res_name;
        resId = voteDetail.id
        votesSum = voteDetail.votes_sum

        $(`#rating-${resName}-${resId}`).html(votesSum);
    })
        .on('ajax:error', function(e) {
            var error = e.detail[0];

            console.log(error);
        })
});
