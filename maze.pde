int boardX;
int boardY;
int roadW;
int[][] map;
int pieceX;
int pieceY;
boolean isPlaying;
boolean isGoal;
float pieceSize;
int playTime;
int[] dirX = {1, 0, -1, 0};
int[] dirY = {0, 1, 0, -1};
boolean isMousePlaying;
boolean inTouch = false;
boolean isSearchLeft;
int pieceDir;
boolean routeMode;
int[] routeDir;
int traceStep;

void setup() {
  size(800, 600);
  makeBoard(13, 9, 46);
  initMaze();
}

void draw() {
  drawMaze();
  drawPiece();
  if (isSearchLeft) {
    searchLeft();
  }
  if (isPlaying || isMousePlaying || isGoal) {
    drawInfo();
  }
  if (routeMode == true) {
    traceRoute();
  }
  checkFinish();
}

void drawPiece() {
  if (isMousePlaying) {
    inTouch = false;
    int posX = mouseX % roadW;
    int posY = mouseY % roadW;
    int pX = mouseX / roadW;
    int pY = mouseY /roadW;
    if (pX >= 2 && pX < boardX-2 && pY >= 2 && pY < boardY - 2) {
      pieceX = pX;
      pieceY = pY;
      if (map[pieceX][pieceY] == (1)
        || (map[pieceX+1][pieceY]==1 && posX > roadW-pieceSize/2)
        || (map[pieceX-1][pieceY]==1 && posX < pieceSize/2)
        || (map[pieceX][pieceY+1]==1 && posY > roadW-pieceSize/2)
        || (map[pieceX][pieceY-1]==1 && posY < pieceSize/2)) {
        inTouch = true;
      }
    }
    if (inTouch == true) {
      fill(138, 43, 226); //ballcolor out
      playTime += 2;
    } else {
      fill(75, 0, 130); //ballcolor in
    }
    ellipse(mouseX, mouseY, pieceSize, pieceSize);
  } else {
    fill(255, 255, 255);//ballcolor goal
    ellipse((pieceX+0.5)*roadW, (pieceY+0.5)*roadW, pieceSize, pieceSize);
  }
}

void drawInfo() {
  if (isPlaying || isMousePlaying) {
    playTime++;
  }
  if (isPlaying == true) {
    playTime += 1;
  }
  textSize(30);
  fill(0);
  text("Time=" + playTime, 20, 30);
}

void checkFinish() {
  if (map[pieceX][pieceY] == (3)) {
    isPlaying = false;
    isMousePlaying = false;
    isGoal = true;
    isSearchLeft = false;
    stroke(255, 0, 0);
    strokeWeight(20);
    noFill();
    ellipse(width/2, height/2, 200, 200);
  }
}

void keyPressed() {
  if (key == 'a')generateMazeUpDown();
  if (key == 'b')generateMazeLeftRight();
  if (key == 'd')generateMazeL();
  if (key == 'k')isPlaying = true;
  if (key == 'i')initMaze();
  if (key == 'r')generateMazeRandom();
  if (key == 'A') {
    makeBoard(13, 9, 46);
    initMaze();
  }
  if (key == 'B') {
    makeBoard(23, 17, 28);
    initMaze();
  }
  if (key == 'C') {
    makeBoard(75, 55, 10);
    initMaze();
  }
  if (key == 'D') {
    makeBoard(155, 115, 5);
    initMaze();
  }
  if (isPlaying) {
    if (keyCode == UP && pieceY > 0 && map[pieceX][pieceY-1] != 1) pieceY -= 1;
    if (keyCode == RIGHT && pieceX < boardX-1 && map[pieceX+1][pieceY] != 1) pieceX += 1;
    if (keyCode == DOWN && pieceY < boardY-1 && map[pieceX][pieceY+1] != 1) pieceY += 1;
    if (keyCode == LEFT && pieceX > 0 && map[pieceX-1][pieceY] != 1) pieceX -= 1;
  }
  if (key == 's')isSearchLeft = true;
  if (key == 'x')searchRoute();
}

void searchRoute() {
  int[][] routeMap = new int[boardX][boardY];
  int routeLength = 0;
  int x =0;
  int y =0;
  int dir = 0;
  int px = 2;
  int py = 3;
  int pdir = (0);
  for (x = 0; x <= boardX-1; x++) {
    for (y = 0; y <= boardY-1; y++) {
      routeMap[x][y] = 10000;
    }
  }
  do {
    for (int j = 0; j < 4; j++) {
      dir =(pdir+3+j)%4;
      x =px+dirX[dir];
      y =py+dirY[dir];
      if (map[x][y] == 0 ||map[x][y] == 3) {
        break;
      }
    }
    pdir = dir;
    px = x;
    py = y;
    if (routeMap[x][y] > routeLength+1) {
      routeMap[x][y] = routeLength+1;
      routeLength++;
    } else {
      routeLength--;
    }
  } while (map[px][py] != 3);
  routeDir = new int[routeLength];
  px = boardX-3;
  py = boardY-4;
  for (int i = routeLength-1; i > -1; i--) {
    for (int j = 0; j < 4; j++) {
      if (routeMap[px+dirX[j]][py+dirY[j]] == i) {
        routeDir[i] = (j+2)%4;
        px = px+dirX[j];
        py = py+dirY[j];
      }
      routeMode = true;
      traceStep = 0;
    }
  }
}

void traceRoute() {
  if (frameCount%10 == 0) {
    pieceX += dirX[routeDir[traceStep]];
    pieceY += dirY[routeDir[traceStep]];
    if (map[pieceX][pieceY] == 3) {
      routeMode = false;
    }
    traceStep++;
  }
}

void generateMazeUpDown() {
  for (int x = 4; x < boardX-3; x += 4) {
    for (int y = 3; y < boardY-4; y++) {
      map[x][y] = 1;
    }
  }
  for (int x =6; x < boardX-3; x += 4) {
    for (int y = boardY-4; y > 3; y--) {
      map[x][y] = 1;
    }
  }
}

void generateMazeLeftRight() {
  for (int y = 4; y < boardY-4; y += 4) {
    for (int x = 3; x <= boardX-5; x++) {
      map[x][y] = 1;
    }
  }
  for (int y = 6; y < boardY-4; y += 4) {
    for (int x = 4; x <= boardX-4; x++) {
      map[x][y] = 1;
    }
  }
}

void generateMazeL() {
  for (int y = 2; y < 9; y ++) {
    map[4][y] = 1;
  }
  for (int x = 4; x <= 12; x++) {
    map[x][8] = 1;
  }
}

void makeBoard(int x, int y, int w) {
  boardX = x + 4;
  boardY = y + 4;
  roadW = w;
  map = new int[boardX][boardY];
}

void initMaze() {
  for (int x=0; x <= boardX-1; x++) {
    for (int y=0; y <= boardY-1; y++) {
      map[x][y] = 1;
    }
  }
  for (int x=3; x <= boardX-4; x++) {
    for (int y=3; y <= boardY-4; y++) {
      map[x][y] = (0);
    }
  }
  map[2][3] = (2);
  map[boardX-3][boardY-4] = (3);
  pieceX = (2);
  pieceY = (3);
  isPlaying = false;
  isGoal = false;
  pieceSize = 0.7*roadW;
  playTime = 0;
  isSearchLeft = false;
  pieceDir = 0;
  routeMode = false;
}


void mousePressed() {
  if (map[mouseX/roadW][mouseY/roadW] == 2) {
    isMousePlaying = true;
  }
}

void drawMaze() {
  noStroke();
  background(100);
  for (int x=2; x <= boardX-3; x++) {
    for (int y=2; y <= boardY-3; y++) {
      if (map[x][y] == (0)) {
        fill(255, 228, 225); //backcolor in
      } else if (map[x][y] == (1)) {
        fill(219, 112, 147); //backcolor adge
      } else if (map[x][y] == (2)) {
        fill(221, 160, 221); //backcolor start
      } else if (map[x][y] == (3)) {
        fill(220, 20, 60); //backcolor goal
      }
      rect(roadW*x, roadW*y, roadW, roadW);
    }
  }
}

void generateMazeRandom() {
  int count;
  do {
    count = 0;
    for (int x = 2; x < boardX-3; x += 2) {
      for (int y = 2; y < boardY-3; y += 2) {
        if (map[x][y] == 1) {
          int r =  int(random(0, 4));
          int dx = dirX[r];
          int dy = dirY[r];
          if (map[x+dx*2][y+dy*2] == 0) {
            map[x+dx*1][y+dy*1] = 1;
            map[x+dx*2][y+dy*2] = 1;
          }
        } else {
          count++;
        }
      }
    }
  } while (count != 0);
}

void searchLeft() {
  int dir=0;
  int x=0;
  int y=0;
  if (frameCount%10 == 0) {
    for (int i = 0; i < 4; i++) {
      dir =(pieceDir+3+i)%4;
      x =pieceX+dirX[dir];
      y =pieceY+dirY[dir];
      if (map[x][y] == 0 ||map[x][y] == 3) {
        break;
      }
    }
    pieceDir = dir;
    pieceX =x;
    pieceY =y;
  }
}
