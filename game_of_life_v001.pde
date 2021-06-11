// Game of Life by Rupert Russell
// 12 July 2021
// Artwork on Redbubble at: 
// Thanks to:
// https://processing.org/examples/gameoflife.html
// https://commons.wikimedia.org/wiki/Category:Animations_of_the_Game_of_Life
// https://commons.wikimedia.org/wiki/File:Oscilador8periodos.gif

int count = 0;
int saveFirstCells = 9;

// Size of cells
int cellSize = 52;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 15;

// Variables for timer
int interval = 3000;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color alive = color(255, 255, 255);
color dead = color(0);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (800, 800);

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(48);
  strokeWeight(10);
  noSmooth();

  // Initialization of cells
  cells[3][3] = 1;
  cells[4][3] = 1;
  cells[6][3] = 1;
  cells[7][3] = 1;
  cells[8][3] = 1;
  cells[9][3] = 1;
  cells[10][3] = 1;
  cells[11][3] = 1;

  cells[3][4] = 1;
  cells[4][4] = 1;
  cells[6][4] = 1;
  cells[7][4] = 1;
  cells[8][4] = 1;
  cells[9][4] = 1;
  cells[10][4] = 1;
  cells[11][4] = 1;

  cells[3][5] = 1;
  cells[3][6] = 1;
  cells[3][7] = 1;
  cells[3][8] = 1;
  cells[3][10] = 1;
  cells[3][11] = 1;  

  cells[4][5] = 1;
  cells[4][6] = 1;
  cells[4][7] = 1;
  cells[4][8] = 1;
  cells[4][10] = 1;
  cells[4][11] = 1;  

  cells[3][10] = 1;
  cells[4][10] = 1;     
  cells[5][10] = 1;
  cells[6][10] = 1;       
  cells[7][10] = 1;
  cells[7][10] = 1;
  cells[8][10] = 1;
  cells[10][10] = 1;
  cells[11][10] = 1;    

  cells[3][11] = 1;
  cells[4][11] = 1;     
  cells[5][11] = 1;
  cells[6][11] = 1;       
  cells[7][11] = 1;
  cells[7][11] = 1;
  cells[8][11] = 1;
  cells[10][11] = 1;
  cells[11][11] = 1;

  cells[10][6] = 1;
  cells[11][6] = 1;
  cells[10][7] = 1;
  cells[11][7] = 1;
  cells[10][8] = 1;
  cells[11][8] = 1;
  cells[10][9] = 1;
  cells[11][9] = 1;

  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {
  translate(10, 10);
  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(alive); // If alive
      } else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(dead); // Fill with kill color
    } else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive color
    }
  } else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      for (int xx=x-1; xx<=x+1; xx++) {
        for (int yy=y-1; yy<=y+1; yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==1) {
                neighbours ++; // Check alive neighbours and count them
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
      } else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbours
        }
      } // End of if
    } // End of y loop
  } // End of x loop

  
  // save frames
  if (count < saveFirstCells) {
    save("frame_" + count + ".png");
    count ++;
  }
} // End of function

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }


  if (key==' ') { // On/off of pause
    pause = !pause;
  }


  if (key=='c' || key == 'C') { 
    // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }


  if (key=='8' || key == '*') { 
    // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }

    cells[3][3] = 1;
    cells[4][3] = 1;
    cells[6][3] = 1;
    cells[7][3] = 1;
    cells[8][3] = 1;
    cells[9][3] = 1;
    cells[10][3] = 1;
    cells[11][3] = 1;
    // cells[12][3] = 1;

    cells[3][4] = 1;
    cells[4][4] = 1;
    cells[6][4] = 1;
    cells[7][4] = 1;
    cells[8][4] = 1;
    cells[9][4] = 1;
    cells[10][4] = 1;
    cells[11][4] = 1;
    // cells[12][4] = 1;

    cells[3][5] = 1;
    cells[3][6] = 1;
    cells[3][7] = 1;
    cells[3][8] = 1;
    cells[3][10] = 1;
    cells[3][11] = 1;  

    cells[4][5] = 1;
    cells[4][6] = 1;
    cells[4][7] = 1;
    cells[4][8] = 1;
    cells[4][10] = 1;
    cells[4][11] = 1;  

    cells[3][10] = 1;
    cells[4][10] = 1;     
    cells[5][10] = 1;
    cells[6][10] = 1;       
    cells[7][10] = 1;
    cells[7][10] = 1;
    cells[8][10] = 1;
    cells[10][10] = 1;
    cells[11][10] = 1;    

    cells[3][11] = 1;
    cells[4][11] = 1;     
    cells[5][11] = 1;
    cells[6][11] = 1;       
    cells[7][11] = 1;
    cells[7][11] = 1;
    cells[8][11] = 1;
    cells[10][11] = 1;
    cells[11][11] = 1;

    cells[10][6] = 1;
    cells[11][6] = 1;
    cells[10][7] = 1;
    cells[11][7] = 1;
    cells[10][8] = 1;
    cells[11][8] = 1;
    cells[10][9] = 1;
    cells[11][9] = 1;
  }

  pause = false;
}
