$(function() {
  var doorBlock = $('.door'),
      btnUp = $('.btn_up'),
      btnDown = $('.btn_down'),
      insideBlock = $('.inside'),
      insideBlockH = $('.inside').height(),
      floorBlock = $('.floor'),
      floorMin = 0,
      floorMax = 6,
      speedBetweenFloor = 600,
      curSpeed = 0,
      flagCanPush = true;
  
  function randomIntFromInterval(min,max){
    return Math.floor(Math.random()*(max-min+1)+min);
}

  var floorCur = floorBlock.html();

  insideBlock.css('top',-(floorCur*insideBlockH));
  
  btnUp.on('click', function(){
    if (flagCanPush) {
      flagCanPush = false;
      moveElevator();
      $(this).addClass('active');
    } else {
      return false;
    }
  });
  
  function moveElevator(){
    curSpeed = floorCur*speedBetweenFloor;
    insideBlock.animate({'top' : 0}, curSpeed, function(){
      setTimeout(openDoor,500);
    });
    goToFloor();
  }
  
  function goToFloor(){
    if(floorCur > 0){
      floorCur-=1;
      floorBlock.html(floorCur+1);
      setTimeout(goToFloor,speedBetweenFloor);
    }
  }
  
  function openDoor(){
    doorBlock.addClass('active');
  }
});