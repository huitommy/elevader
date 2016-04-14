$(document).ready(function() {

  var voteButtons = $('.vote');
  voteButtons.click(function(event) {
    event.preventDefault();

    var review = $(event.target).closest('div[class="card"]');
    var path = $(event.target).closest('form[method="post"]').attr('action');
    var voteDir = $($(event.target).siblings('#vote')[0]).attr('value');
    var voteTotal = review.find('div.vote-total');

    $.ajax({
      url: path,
      method: 'POST',
      datatype: 'json',
      data: { vote: voteDir },
      success: function(response) {
        if (response.status === '200') {
          voteTotal.text(response.votes);
        } else {
          flashError('You cannot vote on your own reviews');
        }
      },
      error: function(response) {
        flashError('You need to sign in or sign up before continuing.');
      }
    });

    var flashError = function(errorMessage) {
      var header = $('header');
      var existingFlashes = header.children('div.flash');
      var html = '<div class="flash alert">' + errorMessage + '<div>';
      existingFlashes.remove();
      header.append(html);
    };
  });

});
