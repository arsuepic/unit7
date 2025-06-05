void keyPressed() {
  if (key == ' ') {
    if (MODE == START) {
      MODE = PLAY;
    } else if (MODE == GAME) {
      v = -10;
    } else if (MODE == GAMEOVER) {
      MODE = START;
      y = height/2;
      v = 0;
      pipeCount = 0;
      boostC = 0;
      score = 0;
      isBoosted = false;
      s = 0;
    }
  }
}
