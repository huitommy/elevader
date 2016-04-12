$(document).ready(function() {

  var voteButtons = $('.vote');
  voteButtons.click(function(event) {
    event.preventDefault();
    var parent = $(event.target).closest('div[class="voting"]')
    var voteTotal = parseInt(parent.find('div.vote-total').text());
  });

});

var $div = $('#divid').closest('div[class^="div-a"]');