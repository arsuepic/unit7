void gameover() {
  textAlign(CENTER);
  
  textSize(32);
  fill(textColor);
  text("Game Over! Score: " + score, width/2, height/2-20);
  text("Press SPACE to restart", width/2, height/2+20);
}
