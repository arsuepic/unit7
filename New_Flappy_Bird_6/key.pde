void keyPressed() {
  if (key == ' ') {
    if (MODE == INTRO) {
      MODE = GAME;

      press.rewind();
      press.play();
    } else if (MODE == GAME) {
      v = -10;

      flap.rewind();
      flap.play();
    } else if (MODE == GAMEOVER) {
      reset();

      press.rewind();
      press.play();
    }
  }
}
