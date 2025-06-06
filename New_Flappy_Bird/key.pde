void keyPressed() {
  if (key == ' ') {
    if (MODE == INTRO) {
      MODE = GAME;
    } else if (MODE == GAME) {
      v = -10;
      
      flap.rewind();
      flap.play();
    } else if (MODE == GAMEOVER) {
      MODE = INTRO;
      y = height/2;
      v = 0;
      pipeC = 0;
      boostC = 0;
      score = 0;
      isBoosted = false;
      s = 0;
      gameover.pause();
    }
  }
}
