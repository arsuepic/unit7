void keyPressed() {
  if (key == ' ') {
    if (MODE == INTRO) {
      MODE = GAME;
    } else if (MODE == GAME) {
      v = -10;
      flap.rewind();
      flap.play();
    } else if (MODE == GAMEOVER) {
      reset();
    }
  }
}
