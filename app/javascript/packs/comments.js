$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.add-comment', function(e) {
        e.preventDefault();
        $(this).hide();
        var commentableType = $(this).data('commentable-type');
        var commentableId = $(this).data('commentable-id');
        $(`#comment-${commentableType}-${commentableId}`).removeClass('hidden');
    })
});
