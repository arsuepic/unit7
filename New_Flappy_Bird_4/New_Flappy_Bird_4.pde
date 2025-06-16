import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer flap, hit, point, gameover;

final float x = 100;
float y;
float v;
final float g = 0.5;
int s;

int MODE;
final int INTRO = 0;
final int GAME = 1;
final int GAMEOVER = 2;

final int maxPipes = 20;
float[] pipeX;
float[] gapY;
boolean[] pipeP;
int pipeC = 0;
float pipeW = 50;
float gapH = 200;

final int maxBoosts = 5;
float[] boostX;
float[] boostY;
int boostC;
boolean isBoosted;
int boostT;
int boostD;

int score;

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
  size(600, 700, P2D);

  minim = new Minim(this);

  flap = minim.loadFile("flap.mp3");
  point = minim.loadFile("point.wav");
  gameover = minim.loadFile("gameover.wav");
  hit = minim.loadFile("hit.wav");

  pipeX  = new float[maxPipes];
  gapY   = new float[maxPipes];
  pipeP  = new boolean[maxPipes];
  boostX = new float[maxBoosts];
  boostY = new float[maxBoosts];

  reset();
}

void draw() {
  background(sky);

  if (MODE == GAME) {
    game();
  } else if (MODE == INTRO) {
    intro();
  } else if (MODE == GAMEOVER) {
    gameover();
  }
}

void reset() {
  MODE = INTRO;
  
  y = height/2;
  v = 0;
  pipeC = 0;
  boostC = 0;
  score = 0;
  isBoosted = false;
  s = 0;
  boostT = 0;
  boostD = 180;

  gameover.pause();
}
