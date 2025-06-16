void game() {
  updateBird();
  updatePipes();
  updateBoosts();
  checkCollisions();
  renderGame();
  manageBoost();
}

void updateBird() {
  v += g;
  y += v;
}

void updatePipes() {
  int i = 0;

  while (i < pipeC) {
    pipeX[i] -= (2 + s);

    if (!pipeP[i] && x > pipeX[i] + pipeW) {
      pipeP[i] = true;
      score++;

      point.rewind();
      point.play();
    }

    i++;
  }

  if (isBoosted == false) {
    if (frameCount % 90 == 0 && pipeC < maxPipes) {
      pipeX[pipeC] = width;
      gapY[pipeC] = random(100, height - 100 - gapH);
      pipeP[pipeC] = false;
      pipeC++;
    }
  } else {
    if (frameCount % 45 == 0 && pipeC < maxPipes) {
      pipeX[pipeC] = width;
      gapY[pipeC] = random(100, height - 100 - gapH);
      pipeP[pipeC] = false;
      pipeC++;
    }
  }

  int j = 0;

  while (j < pipeC) {
    if (pipeX[j] < -pipeW) {
      removePipeAt(j);
    } else {
      j++;
    }
  }
}

void updateBoosts() {
  int i = 0;

  while (i < boostC) {
    boostX[i] -= (2 + s);

    if (dist(x, y, boostX[i], boostY[i]) < 30) {
      isBoosted = true;
      boostT = boostD;
      removeBoostAt(i);
    } else {
      i++;
    }
  }

  if (random(1) < 0.005 && boostC < maxBoosts) {
    boostX[boostC] = width;
    boostY[boostC] = random(50, height - 50);
    boostC++;
  }

  int j = 0;

  while (j < boostC) {
    if (boostX[j] < -20) {
      removeBoostAt(j);
    } else {
      j++;
    }
  }
}

void manageBoost() {
  if (isBoosted) {
    s = 2;
    boostT--;
    if (boostT <= 0) {
      isBoosted = false;
      s = 0;
    }
  }
}

void checkCollisions() {
  if (y > height || y < 0) {
    MODE = GAMEOVER;

    hit.rewind();
    hit.play();

    gameover.rewind();
    gameover.play();
  }

  int i = 0;

  while (i < pipeC) {
    float px = pipeX[i];
    float gy = gapY[i];

    if (x + 20 > px && x - 20 < px + pipeW) {
      if (y - 20 < gy || y + 20 > gy + gapH) {
        if (isBoosted) {
          removePipeAt(i);
          score++;

          point.rewind();
          point.play();
        } else {
          MODE = GAMEOVER;

          hit.rewind();
          hit.play();

          gameover.rewind();
          gameover.play();

          break;
        }
      } else {
        i++;
      }
    } else {
      i++;
    }
  }
}

void renderGame() {
  int i = 0;

  while (i < pipeC) {
    float px = pipeX[i];
    float gy = gapY[i];

    stroke(pipeStroke);
    strokeWeight(2);

    fill(pipeTopColor);
    rect(px, 0, pipeW, gy, 10);

    fill(pipeBotColor);
    rect(px, gy + gapH, pipeW, height - gy - gapH, 10);

    i++;
  }

  pushMatrix();

  translate(x, y);
  noStroke();

  if (isBoosted) {
    fill(birdBoosted);
    triangle(-20, 15, 20, 0, -20, -15);
  } else {
    fill(birdNormal);
    ellipse(0, 0, 40, 30);

    fill(wingColor);
    arc(0, 0, 30, 20, PI / 4, 5 * PI / 4, CHORD);

    fill(eyeColor);
    circle(8, -5, 5);

    fill(beakColor);
    triangle(20, -3, 30, 0, 20, 3);
  }

  popMatrix();

  fill(boostColor);
  noStroke();

  int j = 0;

  while (j < boostC) {
    float bx = boostX[j];
    float by = boostY[j];
    circle(bx, by, 25);

    j++;
  }

  textAlign(CENTER);

  textSize(50);
  fill(textColor);
  text(score, width/2, 50);
}

void removePipeAt(int i) {
  int j = i;

  while (j < pipeC) {
    pipeX[j] = pipeX[j + 1];
    gapY[j] = gapY[j + 1];
    pipeP[j] = pipeP[j + 1];

    j++;
  }

  pipeC--;
}

void removeBoostAt(int i) {
  int j = i;

  while (j < boostC - 1) {
    boostX[j] = boostX[j + 1];
    boostY[j] = boostY[j + 1];

    j++;
  }

  boostC--;
}
