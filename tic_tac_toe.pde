int cols = 3;
int rows = 3;
int[][] board = new int[cols][rows];
int currentPlayer = 1;
int w, h;
int winner = 0;
int xScore = 0;
int oScore = 0;

void setup() {
  size(400, 400);
  w = width / cols;
  h = height / rows;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      board[i][j] = 0;
    }
  }
}

void draw() {
  background(255);
  stroke(0);
  strokeWeight(2);

  for (int i = 1; i < cols; i++) {
    line(i * w, 0, i * w, height);
  }

  for (int j = 1; j < rows; j++) {
    line(0, j * h, width, j * h);
  }

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * w + w / 2;
      float y = j * h + h / 2;
      int spot = board[i][j];
      if (spot == 1) {
        line(x - w / 4, y - h / 4, x + w / 4, y + h / 4);
        line(x + w / 4, y - h / 4, x - w / 4, y + h / 4);
      } else if (spot == -1) {
        ellipse(x, y, w / 2, w / 2);
      }
    }
  }

  int result = checkWinner();
  if (result != 0) {
    noLoop();
    if (result == 1) {
      xScore++;
      println("Player X wins! X Score: " + xScore + " O Score: " + oScore);
    } else if (result == -1) {
      oScore++;
      println("Player O wins! X Score: " + xScore + " O Score: " + oScore);
    } else {
      println("It's a draw! X Score: " + xScore + " O Score: " + oScore);
    }
  }
}

void mousePressed() {
  int i = int(mouseX / w);
  int j = int(mouseY / h);
  if (board[i][j] == 0) {
    board[i][j] = currentPlayer;
    currentPlayer *= -1;
  }
}

int checkWinner() {
  int winner = 0;

  for (int i = 0; i < 3; i++) {
    if (board[i][0] + board[i][1] + board[i][2] == 3 || board[0][i] + board[1][i] + board[2][i] == 3) {
      return 1;
    }
    if (board[i][0] + board[i][1] + board[i][2] == -3 || board[0][i] + board[1][i] + board[2][i] == -3) {
      return -1;
    }
  }

  if (board[0][0] + board[1][1] + board[2][2] == 3 || board[0][2] + board[1][1] + board[2][0] == 3) {
    return 1;
  }
  if (board[0][0] + board[1][1] + board[2][2] == -3 || board[0][2] + board[1][1] + board[2][0] == -3) {
    return -1;
  }

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        return 0;
      }
    }
  }

  return 0;
}
