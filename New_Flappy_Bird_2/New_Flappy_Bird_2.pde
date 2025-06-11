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
float v = 0;
final float g = 0.5;
int s = 0;

int MODE;
final int INTRO = 0;
final int GAME = 1;
final int GAMEOVER = 2;

final int maxPipes = 20;
float[] pipeX = new float[maxPipes];
float[] gapY = new float[maxPipes];
boolean[] pipeP = new boolean[maxPipes];
int pipeC = 0;
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
  y = height/2;

  minim = new Minim(this);
  
  flap = minim.loadFile("flap.mp3");
  point = minim.loadFile("point.wav");
  gameover = minim.loadFile("gameover.wav");
  hit = minim.loadFile("hit.wav");
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
