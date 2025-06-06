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

  if (frameCount % 90 == 0 && pipeC < maxPipes) {
    pipeX[pipeC] = width;
    gapY[pipeC] = random(100, height - 100 - gapH);
    pipeP[pipeC] = false;
    pipeC++;
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
    if (dist(x, y, boostX[i], boostY[i]) < 20) {
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
  // Draw Pipes with rounded corners and nicer green shades
  for (int i = 0; i < pipeC; i++) {
    float px = pipeX[i];
    float gy = gapY[i];

    // Top pipe
    fill(pipeTopColor);
    stroke(pipeStroke);
    strokeWeight(2);
    rect(px, 0, pipeW, gy, 10);

    // Bottom pipe
    fill(pipeBotColor);
    stroke(pipeStroke);
    strokeWeight(2);
    rect(px, gy + gapH, pipeW, height - gy - gapH, 10);
  }

  // Draw Bird (different when boosted)
  pushMatrix();
  translate(x, y);
  noStroke();
  if (isBoosted) {
    fill(birdBoosted);
    // Triangular “turbo” shape
    triangle(-20, 15, 20, 0, -20, -15);
  } else {
    fill(birdNormal);
    ellipse(0, 0, 40, 30);
    // Wing
    fill(wingColor);
    arc(0, 0, 30, 20, PI / 4, 5 * PI / 4, CHORD);
    // Eye
    fill(eyeColor);
    ellipse(8, -5, 5, 5);
    // Beak
    fill(beakColor);
    triangle(20, -3, 30, 0, 20, 3);
  }
  popMatrix();

  // Draw Speed Boosts as simple blue circles
  fill(boostColor);
  noStroke();
  for (int j = 0; j < boostC; j++) {
    float bx = boostX[j];
    float by = boostY[j];
    ellipse(bx, by, 20, 20);
  }

  // Display Score
  textAlign(CENTER);
  textSize(50);
  fill(textColor);
  stroke(textStroke);
  strokeWeight(2);
  text(score, width/2, 50);
}

void removePipeAt(int i) {
  for (int k = i; k < pipeC - 1; k++) {
    pipeX[k] = pipeX[k + 1];
    gapY[k] = gapY[k + 1];
    pipeP[k] = pipeP[k + 1];
  }
  pipeC--;
}

void removeBoostAt(int i) {
  for (int k = i; k < boostC - 1; k++) {
    boostX[k] = boostX[k + 1];
    boostY[k] = boostY[k + 1];
  }
  boostC--;
}
