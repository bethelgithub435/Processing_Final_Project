/*
Bethel Ekelechukwu
 TODO: Make the game
 */

int screen = 0;
boolean gameOver = false;
int score = 0;

// My images
PImage snakeImage;
PImage snakeBg;
PImage appleImage;
PImage snakeHead;
PImage snakeBody;

// integer for snake position
int snakeHeadX = 200;
int snakeHeadY = 230;
int snakeSize = 20;

// integer for movement of the snake
int direction = 0;
int lastMoveTime = 0;

// integer for the food position
int foodX = 200;
int foodY = 150;
int[] snakeBodyX = new int[100];
int[] snakeBodyY = new int[100];

// snake tail
int snakeLength = 1;

void setup () {
  size(700, 450);
  snakeImage = loadImage("snakeimage.png");
  snakeBg = loadImage("snakebg.png");
  appleImage = loadImage("apple.png");
  snakeHead = loadImage("snakehead.png");
  snakeBody = loadImage("snakebody.png");
  snakeBodyX [0] = snakeHeadX;
  snakeBodyY [0] = snakeHeadY;
  // URL for background image in main menu: https://www.androidpolice.com/2019/09/24/chrome-snake-game-leak/
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

    // Snake image near title
    image(snakeImage, 150, 60, 70, 70);
    image(snakeImage, 480, 60, 70, 70);
    
    
  } else if (screen == 1) {
    background(30, 60, 30);

    // Game area
    fill(170, 220, 170);
    rect(50, 50, 600, 350);

    if (millis() - lastMoveTime > 150 && gameOver == false) {

      for (int i = snakeLength - 1; i > 0; i--) {
        snakeBodyX[i] = snakeBodyX[i - 1];
        snakeBodyY[i] = snakeBodyY[i - 1];
      }

      snakeBodyX[0] = snakeHeadX;
      snakeBodyY[0] = snakeHeadY;
      
      // Movement code
      if (direction == 1) {
        snakeHeadY -= 20;
      } else if (direction == 2) {
        snakeHeadY += 20;
      } else if (direction == 3) {
        snakeHeadX -= 20;
      } else if (direction == 4) {
        snakeHeadX += 20;
      }


      if (snakeHeadX < 50 || snakeHeadX >= 650 ||
        snakeHeadY < 50 || snakeHeadY >= 400) {
        gameOver = true;
      }

      for (int i = 1; i < snakeLength; i++) {
        if (snakeHeadX == snakeBodyX[i] &&
          snakeHeadY == snakeBodyY[i]) {
          gameOver = true;
        }
      }

      if (snakeHeadX == foodX && snakeHeadY == foodY) {
        snakeLength++;
        score++;
        
        foodX = (int) random(3, 28) * 20 + 40;
        foodY = (int) random(3, 16) * 20 + 50;
      }

      lastMoveTime = millis();
    }

    // Food
    fill(255, 0, 0);
    image(appleImage, foodX, foodY, 25, 25);

    fill(255);
    textSize(15);
    text("Snake: " + snakeHeadX + ", " + snakeHeadY, 100, 30);
    text("Food: " + foodX + ", " + foodY, 300, 30);
    
    // displaying the score
    fill(255);
    textSize(20);
    text("Score: " + score, 600, 30);

    // Snake
    image(snakeHead, snakeHeadX, snakeHeadY, snakeSize, snakeSize);
    fill(30, 150, 50);
    for (int i = 0; i < snakeLength; i++) {
      rect(snakeBodyX[i], snakeBodyY[i], snakeSize, snakeSize);
      image(snakeBody, snakeBodyX[i], snakeBodyY[i], snakeSize, snakeSize);
    }
    if (gameOver == true) {
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(45);
      text("GAME OVER", 350, 200);

      // Restart button
      fill(30, 150, 50);
      rect(250, 240, 200, 55, 9);

      fill(255);
      textSize(22);
      text("RESTART", 350, 275);
      
      score = 0;
    }
  } else if (screen == 2) {
    background(30, 60, 30);

    // Controls title
    fill(255);
    textAlign(CENTER);
    textSize(40);
    text("CONTROLS", 350, 80);

    // Movement instructions
    textSize(22);
    text("Use the arrow keys to move the snake", 350, 160);
    text("UP / W - Move up", 350, 200);
    text("DOWN / S - Move down", 350, 250);
    text("LEFT / A - Move left", 350, 300);
    text("RIGHT / D - Move right", 350, 350);

    textSize(16);
    fill(200);
    text("Avoid hitting the walls and yourself!", 350, 370);

    // Back to Menu button
    fill(50, 130, 70);
    rect(250, 375, 200, 50, 9);

    fill(255);
    textSize(20);
    text("Back to Menu", 350, 407);
  }
}

void mousePressed () {

  // border radius for the main game
  if (mouseX > 250 && mouseX < 450 &&
    mouseY > 230 && mouseY < 295) {
    screen = 1;
  }

  // border radius for the direction menu
  if (mouseX > 250 && mouseX < 450 &&
    mouseY > 320 && mouseY < 375) {
    screen = 2;
  }

  // Back to Menu button
  if (screen == 2 &&
    mouseX > 250 && mouseX < 450 &&
    mouseY > 375 && mouseY < 425) {
    screen = 0;
  }

  // Restart button
  if (gameOver == true &&
    mouseX > 250 && mouseX < 450 &&
    mouseY > 240 && mouseY < 295) {

    snakeHeadX = 200;
    foodX = 200;
    foodY = 150;
    snakeHeadY = 230;
    snakeLength = 1;
    direction = 0;
    gameOver = false;
    lastMoveTime = millis ();

    snakeBodyX[0] = snakeHeadX;
    snakeBodyY[0] = snakeHeadY;
  }
}


void keyPressed () {
  if (keyCode == UP || keyCode == 'W') {
    direction = 1;
  } else if (keyCode == DOWN || keyCode == 'S') {
    direction = 2;
  } else if (keyCode == LEFT || keyCode == 'A') {
    direction = 3;
  } else if (keyCode == RIGHT || keyCode == 'D') {
    direction = 4;
  }
}

// URL for background image in main menu: https://www.androidpolice.com/2019/09/24/chrome-snake-game-leak/
// URL for apple in game: https://pngtree.com/freepng/fresh-apple-fruit-red_13344485.html
