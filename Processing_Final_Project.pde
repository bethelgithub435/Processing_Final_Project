/*
Bethel Ekelechukwu
 TODO: Make a menu
 */
int screen = 0;
PImage snakeImage;
PImage snakeBg;
int snakeX = 350;
int snakeY = 225;
int snakeSize = 20;

void setup () {
  size(700, 450);
  snakeImage = loadImage("snakeimage.png");
  snakeBg = loadImage("snakebg.png");
}

void draw () {
  // MENU
  if (screen == 0) {
    image(snakeBg, 0, 0, 700, 450);

    // Title
    textAlign(CENTER);
    textSize(45);
    text("Snake Game", 350, 100);

    // Subtitle
    textSize(18);
    text("Eat. Grow. Survive.", 350, 130);

    // Start button
    fill(30, 180, 70);
    rect(250, 230, 200, 65, 9);

    // Controls button
    fill(50, 130, 70);
    rect(250, 320, 200, 55, 9);

    fill(255);
    textSize(25);
    text("Controls", 350, 354);

    fill(255);
    textSize(25);
    text("Start Game", 350, 270);

    image(snakeImage, 150, 60, 70, 70);
    image(snakeImage, 480, 60, 70, 70);
  } else if (screen == 1) {
    background(30, 60, 30);
    
    // Game area
    fill(170, 220, 170);
    rect(50, 50, 600, 350);
  } else if (screen == 2) {
    background(30, 60, 30);
  }
}
void mousePressed () {
  if (mouseX > 250 && mouseX < 450 &&
    mouseY > 230 && mouseY < 295) {
    screen = 1;
  }

  if (mouseX > 250 && mouseX < 450 &&
    mouseY > 320 && mouseY < 375) {
    screen = 2;
  }
}



// URL for background image in main menu: https://www.androidpolice.com/2019/09/24/chrome-snake-game-leak/
