float x = 100;
float y;
float v = 0;
float g = 0.5;
float s = 0;

int MODE;
final int START = 0;
final int GAME = 1;
final int GAMEOVER = 2;

final int maxPipes = 20;
float[] pipeX = new float[maxPipes];
float[] gapY = new float[maxPipes];
boolean[] pipeP = new boolean[maxPipes];
int pipeCount = 0;
float pipeW = 50;
float gapH = 200;

final int maxBoosts = 10;
float[] boostX = new float[maxBoosts];
float[] boostY = new float[maxBoosts];
int boostC = 0;
boolean isBoosted = false;
int boostT = 0;
int boostD = 180;

int score = 0;

// Colour declarations
color black         = #000000;
color white         = #FFFFFF;
color sky           = #87CEEB;  // Sky blue
color pipeTopColor  = #228B22;  // Medium green
color pipeBotColor  = #32CD32;  // Light green
color pipeStroke    = #006400;  // Dark gree
color birdNormal    = #FFCC00;  // Yellow
color birdBoosted   = #FF4500;  // Red
color wingColor     = #FFA500;  // Orange
color eyeColor      = #000000;  // Black
color beakColor     = #FF8C00;  // Dark orange
color boostColor    = #1E90FF;  // Blue
color textColor     = #FFFFFF;  // White
color textStroke    = #000000;  // Black

void setup() {
  size(600, 800);
  y = height/2;
}

void draw() {
  background(sky);

  if (gameState.equals("playing")) {
    updateBird();
    updatePipes();
    updateBoosts();
    checkCollisions();
    renderGame();
    manageBoost();
  } else if (gameState.equals("start")) {
    textAlign(CENTER);
    textSize(32);
    fill(textColor);
    text("Press SPACE to start", width / 2, height / 2);
  } else if (gameState.equals("game_over")) {
    textAlign(CENTER);
    textSize(32);
    fill(textColor);
    text("Game Over! Score: " + score, width / 2, height / 2 - 20);
    text("Press SPACE to restart", width / 2, height / 2 + 20);
  }
}

void updateBird() {
  v += g;
  y += v;
}

void updatePipes() {
  int i = 0;
  while (i < pipeCount) {
    pipeX[i] -= (2 + s);
    if (!pipeP[i] && x > pipeX[i] + pipeW) {
      pipeP[i] = true;
      score++;
    }
    i++;
  }

  if (frameCount % 80 == 0 && pipeCount < maxPipes) {
    pipeX[pipeCount] = width;
    gapY[pipeCount] = random(100, height - 100 - gapH);
    pipeP[pipeCount] = false;
    pipeCount++;
  }

  int j = 0;
  while (j < pipeCount) {
    if (pipeX[j] < -pipeW) {
      removePipeAt(j);
    } else {
      j++;
    }
  }
}

void removePipeAt(int index) {
  for (int k = index; k < pipeCount - 1; k++) {
    pipeX[k] = pipeX[k + 1];
    gapY[k] = gapY[k + 1];
    pipeP[k] = pipeP[k + 1];
  }
  pipeCount--;
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

void removeBoostAt(int index) {
  for (int k = index; k < boostC - 1; k++) {
    boostX[k] = boostX[k + 1];
    boostY[k] = boostY[k + 1];
  }
  boostC--;
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
  }

  int i = 0;
  while (i < pipeCount) {
    float px = pipeX[i];
    float gy = gapY[i];
    if (x + 20 > px && x - 20 < px + pipeW) {
      if (y - 20 < gy || y + 20 > gy + gapH) {
        if (isBoosted) {
          removePipeAt(i);
          score++;
        } else {
          MODE = GAMEOVER;
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
  for (int i = 0; i < pipeCount; i++) {
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
  text(score, width / 2, 50);
}
