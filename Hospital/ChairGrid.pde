//consists of two grids, similar to tally marks
class ChairGrid{
  //fields
  int leftXpos;
  int middleYpos;
  
  int chairNum;
  
  int xStart;
  
  //constructor
  ChairGrid(int x, int y,int c){
    this.leftXpos=x;
    this.middleYpos=y;
    this.chairNum=c;
    
  }


  //draws grid of chairs
  void display(){
    xStart=leftXpos;
    for (int i=0; i<chairNum+1; i++){
      
      strokeWeight(5);
      stroke(0);
      line(xStart,middleYpos-15,xStart,middleYpos+15);
      line(leftXpos,middleYpos,leftXpos+15*(chairNum),middleYpos);
      
      xStart+=15;
    }
  }

}
