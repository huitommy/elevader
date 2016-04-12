$(document).ready(function() {

  var voteButtons = $('.vote');
  voteButtons.click(function(event) {
    event.preventDefault();
    var parent = $(event.target).closest('div[class="voting"]')
    var voteTotal = parent.find('div.vote-total');
    // Send vote to server
    // Server changes votes and total count
    // Upon receipt of success message, ajax changes total count
  });

});

var $div = $('#divid').closest('div[class^="div-a"]');