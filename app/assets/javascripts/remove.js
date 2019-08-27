$(document).ready(function() {
  $(document).on('ajax:success', '.remove', function (e) {
    $(this).closest(".row").append(e.detail[0].activeElement.innerHTML);
    $('.modal').modal('show');
  });

  $(document).on('ajax:success', '.edit_remove_post_form, .edit_remove_comment_form', function(e) {
    var new_approve_link = e.detail[0].approve_link;
    var new_remove_link = e.detail[0].remove_link;
    var approve_link = $(this).closest(".row").find(".approve");
    var remove_link = $(this).closest(".row").find(".remove");

    $('.modal').modal("hide");
    $(approve_link).tooltip("hide");
    $(remove_link).tooltip("hide");
    $(approve_link).replaceWith(new_approve_link);
    $(remove_link).replaceWith(new_remove_link);
    $('[data-toggle="tooltip"]').tooltip();
  });
});