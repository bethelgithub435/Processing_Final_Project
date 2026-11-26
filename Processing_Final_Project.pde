/*
Bethel Ekelechukwu
 Snake Game
 */


import processing.sound.*;

SoundFile moveSound;
SoundFile eatSound;
SoundFile gameOverSound;

// Controls which screen is displayed
// 0 = Main Menu, 1 = Game, 2 = Controls
int screen = 0;

boolean gameOver = false;
boolean paused = false;

int score = 0;
int highScore = 0;

// Images used in the game
PImage snakeImage;
PImage snakeBg;
PImage snakeBody;
PImage appleTest2;

// Snake's starting position and size
int snakeHeadX = 210;
int snakeHeadY = 250;
int snakeSize = 20;

// Controls how the snake moves
// 0 = Not moving, 1 = Up, 2 = Down, 3 = Left, 4 = Right
int direction = 0;
int lastMoveTime = 0;
int speed = 150;

// Apple's starting position
int appleX = 210;
int appleY = 150;

// Arrays store the X and Y positions of each snake body section
int[] snakeBodyX = new int[100];
int[] snakeBodyY = new int[100];

// Keeps track of how many sections the snake has
int snakeLength = 1;

void setup () {
  size(700, 450);

  JSONObject loadedScore = loadJSONObject(dataPath("highscore.json"));

  if (loadedScore != null) {
    highScore = loadedScore.getInt("highScore");
  }


  // Loads the images used in the game
  snakeImage = loadImage("snakeimage.png");
  snakeBg = loadImage("snakebg.png");
  snakeBody = loadImage("snakebody.png");
  appleTest2 = loadImage("appletest2.png");

  // Sets the first body section
  snakeBodyX[0] = snakeHeadX;
  snakeBodyY[0] = snakeHeadY;

  // Loads the sound effects
  moveSound = new SoundFile(this, "move.mp3");
  eatSound = new SoundFile(this, "crunch.mp3");
  gameOverSound = new SoundFile(this, "gameOver.mp3");
}

void draw () {

  // Displays the main menu
  if (screen == 0) {
    image(snakeBg, 0, 0, 700, 450);

    textAlign(CENTER);
    textSize(45);
    text("Snake Game", 350, 100);

    textSize(18);
    text("Eat. Grow. Survive.", 350, 130);

    fill(30, 180, 70);
    rect(250, 230, 200, 65, 15);

    fill(50, 130, 70);
    rect(250, 320, 200, 55, 15);

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


    // Grid background
    rect(50, 50, 600, 340);
    stroke(0, 0, 0);

    // Draws the vertical grid lines
    for (int x = 50; x <= 650; x += 20) {
      line(x, 50, x, 390);
    }

    // Draws the horizontal grid lines
    for (int y = 50; y <= 390; y += 20) {
      line(50, y, 650, y);
    }

    noStroke();

    // millis() checks how much time has passed
    // The snake only moves when enough time has passed and the game isn't paused or over
    if (millis() - lastMoveTime > speed && gameOver == false && paused == false) {

      // Moves each body section to the position of the section in front of it
      // This makes the snake's body follow its head
      for (int i = snakeLength - 1; i > 0; i--) {
        snakeBodyX[i] = snakeBodyX[i - 1];
        snakeBodyY[i] = snakeBodyY[i - 1];
      }

      // Saves the head's previous position as the first body section
      snakeBodyX[0] = snakeHeadX;
      snakeBodyY[0] = snakeHeadY;

      // Direction 1 = Up, Direction 2 = Down, Direction 3 = Left, Direction 4 = Right
      if (direction == 1) {
        snakeHeadY -= 20;
        moveSound.play();
      } else if (direction == 2) {
        snakeHeadY += 20;
        moveSound.play();
      } else if (direction == 3) {
        snakeHeadX -= 20;
        moveSound.play();
      } else if (direction == 4) {
        snakeHeadX += 20;
        moveSound.play();
      }

      // Checks if the snake has hit the walls
      if (snakeHeadX < 50 || snakeHeadX >= 650 || snakeHeadY < 50 || snakeHeadY >= 390) {
        gameOver = true;
        gameOverSound.play();
      }

      // Checks if the snake has collided with its own body
      for (int i = 1; i < snakeLength; i++) {
        if (snakeHeadX == snakeBodyX[i] && snakeHeadY == snakeBodyY[i]) {
          gameOver = true;
          gameOverSound.play();
        }
      }

      // Checks if the snake's head is touching the apple
      if (snakeHeadX == appleX && snakeHeadY == appleY) {

        eatSound.play();

        // Makes the snake longer, increases the score and increases its speed
        snakeLength++;
        score++;
        speed -= 2;


        // Gives the new body section the previous tail position
        snakeBodyX[snakeLength - 1] = snakeBodyX[snakeLength - 2];
        snakeBodyY[snakeLength - 1] = snakeBodyY[snakeLength - 2];


        // Generates a new apple at a random position on the grid
        appleX = (int) random(0, 30) * 20 + 50;
        appleY = (int) random(0, 17) * 20 + 50;
      }

      // Resets the movement timer
      lastMoveTime = millis();
    }

    // Draws the apple
    fill(255, 0, 0);
    image(appleTest2, appleX, appleY, 20, 20);

    // Pause button
    fill(50, 130, 70);
    rect(470, 10, 100, 30, 9);

    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("PAUSE", 520, 31);

    // Main Menu button
    fill(50, 130, 70);
    rect(365, 10, 100, 30, 8);

    fill(255);
    textSize(16);
    text("MAIN MENU", 415, 31);


    // Snakes coordinates
    fill(255);
    textSize(15);
    text("Snake: " + snakeHeadX + ", " + snakeHeadY, 100, 30);
    text("Food: " + appleX + ", " + appleY, 200, 30);

    // Displays the player's score
    fill(255);
    textSize(20);
    text("Score: " + score, 650, 30);
    image(appleTest2, 590, 7, 35, 35);

    // Draws the snake's head and body
    image(snakeBody, snakeHeadX, snakeHeadY, snakeSize, snakeSize);
    fill(30, 150, 50);

    for (int i = 0; i < snakeLength; i++) {
      rect(snakeBodyX[i], snakeBodyY[i], snakeSize, snakeSize);
      image(snakeBody, snakeBodyX[i], snakeBodyY[i], snakeSize, snakeSize);
    }

    // Displays the Game Over screen when the snake loses
    if (gameOver == true) {

      // Checks if the player achieved a new high score
      if (score > highScore) {
        highScore = score;

        // Once game is over and you have a new high score it will save into a JSON file
        JSONObject savedScore = new JSONObject();
        savedScore.setInt("highScore", highScore);

        saveJSONObject(savedScore, dataPath("highscore.json"));


        gameOverSound.play();
      }

      // GAME OVER BACKGROUND

      // Transparent grey background
      fill(50, 50, 50, 150);
      rect(0, 0, 700, 450);

      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(45);
      text("GAME OVER", 350, 200);

      textSize(22);
      fill(255);
      text("Your Score: " + score, 350, 375);

      textSize(22);
      fill(255);
      text("High Score: " + highScore, 350, 330);

      // Restart button
      fill(30, 150, 50);
      rect(250, 240, 200, 55, 9);

      fill(255);
      textSize(22);
      text("RESTART", 350, 275);
    }

    // Displays the pause overlay when the game is paused
    if (paused == true) {

      fill(100, 100, 100, 180);
      rect(0, 0, 700, 450);

      fill(255);
      textAlign(CENTER);
      textSize(45);
      text("PAUSED", 350, 250);

      // Home button
      fill(50, 130, 70);
      rect(550, 380, 120, 50, 10);

      fill(255);
      textSize(20);
      text("HOME", 610, 412);
    }
  } else if (screen == 2) {

    // Displays the controls screen
    background(30, 60, 30);

    fill(170, 220, 170);
    rect(55, 0, 600, 500);

    fill(20);
    textAlign(CENTER);
    textSize(40);
    text("CONTROLS", 350, 60);

    textSize(22);
    text("Use the arrow keys to move the snake", 350, 120);
    text("UP / W - Move up", 350, 160);
    text("DOWN / S - Move down", 350, 205);
    text("LEFT / A - Move left", 350, 250);
    text("RIGHT / D - Move right", 350, 300);

    textSize(16);
    fill(20);
    text("Avoid hitting the walls and yourself!", 350, 350);

    // Back to Menu button
    fill(50, 130, 70);
    rect(250, 375, 200, 50, 15);

    fill(255);
    textSize(20);
    text("Back to Menu", 350, 407);
  }
}

void mousePressed () {

  // Checks if the player clicked the Pause button
  if (screen == 1 && gameOver == false && mouseX > 470 && mouseX < 570 && mouseY > 10 && mouseY < 40) {
    paused = !paused;
  }

  // Returns to the main menu when clicked
  if (screen == 1 && mouseX > 365 && mouseX < 465 && mouseY > 10 && mouseY < 40) {
    screen = 0;
    paused = false;
  }

  // Checks if the player clicked the Start Game button
  if (screen == 0 && mouseX > 250 && mouseX < 450 && mouseY > 230 && mouseY < 295) {
    screen = 1;

    // Resets the game variables for a new game
    snakeHeadX = 210;
    snakeHeadY = 250;
    snakeLength = 1;
    direction = 0;
    score = 0;
    speed = 150;
    gameOver = false;

    snakeBodyX[0] = snakeHeadX;
    snakeBodyY[0] = snakeHeadY;

    appleX = 210;
    appleY = 150;

    lastMoveTime = millis ();
  }

  // Checks if player clicks the "CONTROLS" menu in the main menu
  // Opens the controls screen
  if (screen == 0 && mouseX > 250 && mouseX < 450 && mouseY > 320 && mouseY < 375) {
    screen = 2;
  }

  // Returns from the controls screen to the menu
  if (screen == 2 && mouseX > 250 && mouseX < 450 && mouseY > 375 && mouseY < 425) {
    screen = 0;
  }

  // Restarts the game when the Restart button is clicked
  if (gameOver == true && mouseX > 250 && mouseX < 450 && mouseY > 240 && mouseY < 295) {

    snakeHeadX = 210;
    appleX = 210;
    appleY = 150;
    snakeHeadY = 250;
    snakeLength = 1;
    direction = 0;
    gameOver = false;
    lastMoveTime = millis ();

    snakeBodyX[0] = snakeHeadX;
    snakeBodyY[0] = snakeHeadY;

    score = 0;
    speed = 150;
  }

  // Returns to the menu using the Home button while paused
  if (screen == 1 && paused == true && mouseX > 550 && mouseX < 670 && mouseY > 380 && mouseY < 430) {

    screen = 0;
    paused = false;
  }
}

void keyPressed () {

  // Changes direction using arrow keys or WASD
  // Prevents the snake from immediately reversing into itself
  if (keyCode == UP || key == 'w' || key == 'W') {
    if (direction != 2) {
      direction = 1;
    }
  } else if (keyCode == DOWN || key == 's' || key == 'S') {
    if (direction != 1) {
      direction = 2;
    }
  } else if (keyCode == LEFT || key == 'a' || key == 'A') {
    if (direction != 4) {
      direction = 3;
    }
  } else if (keyCode == RIGHT || key == 'd' || key == 'D') {
    if (direction != 3) {
      direction = 4;
    }
  }

  // Press P to pause or resume the game
  if (screen == 1 && !gameOver && (key == 'p' || key == 'P')) {
    paused = !paused;
  }

  // Press M to return to the main menu
  if (keyCode == 'M' || keyCode == 'm') {
    screen = 0;
  }

  // Press R to restart the game
  if (screen == 1 && gameOver && (keyCode == 'R' || keyCode == 'r')) {
    snakeHeadX = 210;
    appleX = 210;
    appleY = 150;
    snakeHeadY = 250;
    snakeLength = 1;
    direction = 0;
    gameOver = false;
    lastMoveTime = millis ();

    snakeBodyX[0] = snakeHeadX;
    snakeBodyY[0] = snakeHeadY;
  }
}

// Image sources:
// Background: https://www.androidpolice.com/2019/09/24/chrome-snake-game-leak/
// Apple: https://pngtree.com/freepng/fresh-apple-fruit-red_13344485.html
