final int NB_CASE = 3; 
  
int[][] grid = new int[NB_CASE][NB_CASE]; 

                
boolean over = false;   
boolean started = false;
boolean menu; 
boolean turn_choice_view; 
boolean ai_mode;
                
boolean player1_choice; 
boolean starting_turn = true; 
boolean turn; 

boolean show_help = false; 
boolean show_scores = true;
boolean ai_turn = false;

int p1wins, draws, p2wins;
int AI_DELAY=500;

HashMap<Integer, Integer> rewards = new HashMap<Integer, Integer>(); 

void setup(){
  size(512, 512);
  

  rewards.put(2, 10);
  rewards.put(1, -10); 
  rewards.put(0, 0); 
  

  open_menu();
}


void draw(){
    if(ai_turn){
        delay(AI_DELAY);
        AI_Turn();
        ai_turn = false;
    }
}

/* ##################################   DRAWING FUNCTIONS   ###################################### */

void open_menu(){
  started = false;
  menu = true;
  ai_mode = false;
  p1wins = 0; p2wins = 0; draws = 0;
  
    // text part  
    int textSize = 40;
    textAlign(CENTER, CENTER);
    
        // big title part
        textSize(textSize);
        fill(#E74C3C);
        background(12, 13, 59);
        text("TIC-TAC-TOE", width/2, height/8);
        
        // subtitles part
        textSize(textSize/1.5);
        fill(#FFD6E8);
        text("Tekan 'A' untuk bermain bersama AI", width/2, height/1.2-textSize);
        fill(#CD6155);
        text("Tekan 'P' untuk bermain dengan pemain lain", width/2, height/1.2);
        
        
     // shape part
      int spacing = 60;
      strokeWeight(5);
      stroke(#F2D7D5, 150);
      line(width/3, height/2.5, 2*width/3, height/2.5);
      line(width/3, height/2.5+spacing, 2*width/3, height/2.5+spacing);
      line(4*width/9, height/3.5, 4*width/9, height/3.5+3*spacing);
      line(4*width/9+spacing, height/3.5, 4*width/9+spacing, height/3.5+3*spacing);    
}


void open_turn_choice(){
 
  fill(0, 240);
  noStroke();
  rect(0,0,width,height);
  
  // big title part
        textSize(40);
        fill(#A7F3FF);
        text("TIC-TAC-TOE", width/2, height/8);
  
  //fill(#156F6E, 150);
  strokeWeight(5);
  stroke(255, 100);
  noFill();
  rect(width/9,height/3,7*width/9,height/2.5+40, 30);
  turn_choice_view = true;

  // text part
    int textSize = 40;
    textAlign(CENTER, CENTER);
    
        // big title part
        textSize(textSize);
        fill(#FFE374);
        text("Player 1", width/2, height/3+45);
        stroke(#FFE374,200);
        strokeWeight(3);
        line(width/2-textWidth("Player 1")/2, height/3+45+textSize/2, width/2+textWidth("Player 1")/2-5, height/3+45+textSize/2);
        
        // subtitles part
        textSize(textSize/1.5);
        fill(#FFC1C2, 220);
        text("Tekan 'x' untuk bermain sebagai X", width/2, height/2+45);
        fill(#C1FFFE, 220);
        text("Tekan 'o' untuk bermain sebagai O", width/2, height/2+1.2*textSize+45);

}


void draw_grid(){
  int x = 0;
  int y = 0;
  
  fill(12, 13, 59);  
  stroke(255);    
  strokeWeight(5);
  
  while(y<height){
    while(x<width){
      rect(x, y, width/NB_CASE, height/NB_CASE);
      x += width/NB_CASE;
    }
    x = 0;
    y += height/NB_CASE;
  }
}


void updateGrid(){
   
    draw_grid();

  
    int box_width = width/NB_CASE;
    int box_height = height/NB_CASE;
    
    int padding = 40;
    fill(12, 13, 59);
    
    if(player1_choice){
      for(int i=0; i<NB_CASE; i++){
          for(int j=0; j<NB_CASE; j++){
              if(grid[i][j] == 1){
                  // buat gambar silang (x)
                  stroke(#FFC1C2);      
                  strokeWeight(5);       
                  line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
                  line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
                  
              }
              else{
                  if(grid[i][j] == 2){
                      // buat gambar lingkaran (o)
                      stroke(#C1FFFE); 
                      strokeWeight(5);  
                      circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
                  }
              }
          }
      }
    }
    else{
      for(int i=0; i<NB_CASE; i++){
          for(int j=0; j<NB_CASE; j++){
              if(grid[i][j] == 2){
                  stroke(#FFC1C2);   
                  strokeWeight(5);  
                  line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
                  line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
                  
              }
              else{
                  if(grid[i][j] == 1){
                      // draw a circle
                      stroke(#C1FFFE); 
                      strokeWeight(5); 
                      circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
                  }
              }
          }
      }
    }
    
    
    
  
    if(ai_mode){
      if(show_help&&started&&(turn==player1_choice)){ 
          showHelp();
      }
    }
    else{                            
      if(show_help&&started){      
          showHelp();
      }
    }
    
    
    
    if(show_scores){
      
      // prints scores
      textAlign(CENTER, CENTER);
      fill(255, 100);
      if(!player1_choice)
          fill(#FFFFFF);   
        else
          fill(#FFFFFF);   
      text("P1 menang! : "+str(p1wins), box_width/2, height*0.96);
      fill(#FFFFFF);
      text("Seri : "+str(draws), box_width+box_width/2, height*0.96);
      if(player1_choice)
          fill(#FFFFFF);   
        else
          fill(#FFFFFF);    
      if(ai_mode){
        text("AI menang! : "+str(p2wins), 2*box_width+box_width/2, height*0.96);
        }
      else
        text("P2 menang! : "+str(p2wins), 2*box_width+box_width/2, height*0.96);
        
      
      if(turn==player1_choice){
        if(player1_choice)
          fill(#FFFFFF);   
        else
          fill(#FFFFFF);     
        text("Gantian : P1", 2*box_width+box_width/2, height*0.04);
      }
      else{
         if(!player1_choice)
           fill(#FFFFFF);     
         else
           fill(#FFFFFF);     
           
         if(ai_mode)
           text("Gantian : AI", 2*box_width+box_width/2, height*0.04);
         else
           text("Gantian : P2", 2*box_width+box_width/2, height*0.04);   
      }
      
    }
    
}


void showHelp(){
  
  if(check_winner()==-1){
        int[] bestPlayerMove = new int[2];
        if(turn==!(player1_choice)&&!(ai_mode))
            bestPlayerMove = getBestMove(2);
        else
            bestPlayerMove = getBestMove(1);
        int i = bestPlayerMove[0];
        int j = bestPlayerMove[1];
        
        int box_width = width/NB_CASE;
        int box_height = height/NB_CASE;
        
        int padding = 60;
        
        if(turn){
          stroke(255, 60);  
          strokeWeight(5);   
          line(i*box_width+padding, j*box_height+padding, (i+1)*box_width-padding, (j+1)*box_height-padding);
          line(i*box_width+padding, (j+1)*box_height-padding, (i+1)*box_width-padding, j*box_height+padding);
        }
        else{
          // gambar lingkaran
          stroke(255,60);  
          fill(12, 13, 59);
          strokeWeight(5); 
          circle(i*box_width+box_width/2, j*box_height+box_height/2, box_width-1.8*padding);
        }
  }
}


/* ##################################   PROCESSING FUNCTIONS   ###################################### */


void initialize_grid(){
  for(int i=0; i<NB_CASE; i++){
      for(int j=0; j<NB_CASE; j++){
          grid[i][j] = 0;
      }
  }
}


void start_2players_mode(){
    started = true; 
    turn = starting_turn;
    starting_turn = !starting_turn; 
    initialize_grid();
    updateGrid();
    if(show_help)
          showHelp();
}


void start_ai_mode(){
  
    started = true;
    turn = starting_turn;
    starting_turn = !starting_turn;
    initialize_grid();
    updateGrid();
    if(turn == !player1_choice){
      AI_Turn();
    }
    
    if(show_help)
      showHelp();
}


boolean equals3(int a, int b, int c){
    if((a == b) && (b == c))
        return true;
    else
        return false;
}



int check_winner(){
  for (int i = 0; i < 3; i++) {
    if (equals3(grid[i][0], grid[i][1], grid[i][2]) && (grid[i][0] != 0)) {
      return grid[i][0];
    }
  }
  
  for (int i = 0; i < 3; i++) {
    if (equals3(grid[0][i], grid[1][i], grid[2][i]) && (grid[0][i] != 0)) {
      return grid[0][i];
    }
  }
  

  if(equals3(grid[0][0], grid[1][1], grid[2][2]) && (grid[0][0] != 0))
      return grid[0][0];
  if(equals3(grid[2][0], grid[1][1], grid[0][2]) && (grid[2][0] != 0))
      return grid[2][0];
      
      

      for(int i=0; i<NB_CASE; i++){
        for(int j=0; j<NB_CASE; j++){
           if(grid[i][j]==0) return -1; 
        }
      }
      
  return 0;
  
}


boolean check_if_over(){
    int winner = check_winner();
    
    if(winner == -1) 
      return false;
    
 
    int text_size = 50;
    fill(0, 200);
    strokeWeight(2);
    stroke(0);
    rect(0, 0, width, height);
    textSize(text_size);
    textAlign(CENTER, CENTER);
    
 
    if(winner == 1){
        if(player1_choice)
          fill(#FFC1C2);
        else
          fill(#C1FFFE);
        text("Player 1 menang !", width/2, height/2);
        p1wins++;
    }
    else{
      if(winner == 2){
        if(player1_choice)
          fill(#C1FFFE); 
        else
          fill(#FFC1C2); 
        if(ai_mode)
          text("AI menang !", width/2, height/2);
        else
          text("Player 2 menang !", width/2, height/2);
        p2wins++;
      }
      else{
        if(winner == 0){
        fill(255);
        text("Tie !", width/2, height/2);
        draws++;
        }
        else
            print("Error");
      }
    }
    fill(255, 180);
    textSize(text_size/2.5);
    text("Tekan spasi untuk main lagi", width/2, height/2+text_size);
    textSize(text_size/3);
    fill(#C1FFCB, 150);
    text("Tekan 'm' untuk kembali", width/2, height - text_size/2);
    return true;
}


void mouseClicked() {
  
  if((!over)&&(started)&&(!ai_turn)){
    int box_width = width/NB_CASE;
    int box_height = height/NB_CASE;
    
    int x = mouseX / box_width;
    int y = mouseY / box_height;
    
    boxClicked(x, y);
  }
}

void boxClicked(int x, int y){
  
  if(grid[x][y] == 0){
      if(turn==player1_choice)
          // player 1 turn
          grid[x][y] = 1;
      else
          grid[x][y] = 2;
      
      turn = !turn;
      show_help = false;
      updateGrid();
      over = check_if_over();
      
      
      
      if((ai_mode)&&(!over)){ 
        ai_turn=true;
      }
  }
}

void keyPressed(){

    
    if(menu){ 
 
        if((key=='p')||(key=='P')){
            ai_mode = false;
            print("2 Players mode\n");
            menu = false;
            open_turn_choice();
        }
        
        else{
          if((key=='a')||(key=='A')){
            print("AI mode\n");
            ai_mode=true;
            menu = false;
            open_turn_choice();
          }
        }
    }
    
    if(turn_choice_view){
        if((key=='x')||(key=='X')){
          // Player 1 choosed to play with X
          player1_choice = true;
          starting_turn = player1_choice;
          turn_choice_view = false;
          if(ai_mode)
              start_ai_mode();
          else
              start_2players_mode();
        
        }
        else{
          if((key=='o')||(key=='O')){
            // Player 1 choosed to play with X
            player1_choice = false;
            starting_turn = player1_choice;
            turn_choice_view = false;
            if(ai_mode)
                start_ai_mode();
            else
                start_2players_mode();          
          }
          else{
            if((key=='m')||(key=='M')){
              // Go back to menu
              turn_choice_view = false;
              open_menu();
            }
          }
        }
    }
    
    if(started&&!(over)){
        if((key=='s')||(key=='S')){
            show_scores = !show_scores;
            updateGrid();
        }
        if((key=='h')||(key=='H')){
            show_help = true;
            if(ai_mode)
              showHelp();
            updateGrid();
        }
    }
  
  
    if(over){ 
        if(key==' '){
          over = false;
          if(ai_mode)
              start_ai_mode();
          else
              start_2players_mode();
        }
        
        if((key=='m')||(key=='M')){
            over = false;
            open_menu();
        }
          
    }
}




/* ######################################     AI    PART    ############################################# */

void AI_Turn(){
        makeBestMove(); 
        turn = !turn; 
        updateGrid();
        over = check_if_over();     
}

void makeBestMove(){
  int[] bestMove = new int[2];
  bestMove = getBestMove(2);
  grid[bestMove[0]][bestMove[1]] = 2;   
}

int[] getBestMove(int maximizer) {
 
  int bestReward = (int) Double.NEGATIVE_INFINITY;     

  int[] bestMove = new int[2]; 
  

  for(int i = 0; i<NB_CASE; i++){
    for (int j = 0; j<NB_CASE; j++){

      if (grid[i][j] == 0) {
        grid[i][j] = maximizer;                    
        int reward = minimax(false, maximizer);        
        grid[i][j] = 0;                    
        if (reward > bestReward) {           
          bestReward = reward;
          bestMove[0] = i;
          bestMove[1] = j;
        }
      }
     }
  }
  return bestMove;
}


int minimax(boolean isMaximizing, int maximizer) {

  // check if game over
  int winner = check_winner();   
  if (winner != -1) {   
    if(maximizer == 2)
      return rewards.get(winner);   
    else
      return -rewards.get(winner); 
  }
  
  int minimizer;
  if(maximizer == 2)
      minimizer=1;
  else
      minimizer=2;
  

  if (isMaximizing) {
    
    int maxReward = (int) Double.NEGATIVE_INFINITY; 
    
    for (int i = 0; i < NB_CASE; i++) {
      for (int j = 0; j < NB_CASE; j++) {
        if (grid[i][j] == 0) {  
          grid[i][j] = maximizer;          
          int reward = minimax(false, maximizer);   
          grid[i][j] = 0;  
          maxReward = max(reward, maxReward);   
        }
      }
    }
    return maxReward;
  } 
  
  else {
    
    int minReward = (int) Double.POSITIVE_INFINITY;  
    
    for (int i = 0; i < NB_CASE; i++) {
      for (int j = 0; j < NB_CASE; j++) {
        
        if (grid[i][j] == 0) {  
          grid[i][j] = minimizer;  
          int reward = minimax(true, maximizer); 
          grid[i][j] = 0;       
          minReward = min(reward, minReward); 
        }
      }
    }
    return minReward;
  }
}
