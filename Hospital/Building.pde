class Building{
  //fields
  int numRooms;
  int pathWidth;
  
  int xWidth;
  int yWidth;
  
  int doorOffset;
  
  int screenWidth;
  int screenLength;
  
  int doorWidth;
  
  ArrayList <Room> rooms = new ArrayList <Room>();
  
  //constructor
  Building(int r,int p,int w, int l, int dw){
    this.numRooms = r;
    this.pathWidth=p;
    this.screenWidth = w;
    this.screenLength = l;
    this.doorWidth=dw;   //please limit doorwidth on GUI to something relative to max rooms :D
    this.xWidth = (this.screenWidth-pathWidth)/2;
    this.yWidth = this.screenLength*2/3/(this.numRooms/2+this.numRooms%2);
    
    
  }
  
  //makes new building and room coordinates
  void createBuilding(){
    rooms = new ArrayList <Room>();
    allDoctors = new ArrayList<Doctor>();
    this.xWidth = (this.screenWidth-pathWidth)/2;
    this.yWidth = this.screenLength*2/3/(this.numRooms/2+this.numRooms%2);
    if (this.numRooms!=0){
      for (int i=0; i<this.numRooms; i++){
     
        Room currRoom = new Room();
        currRoom.yPos = i/2*yWidth;
        rooms.add(currRoom);
        
        if (i%2==0){
          currRoom.xPos = 0;
        }
        else{
          currRoom.xPos = width-(width-this.pathWidth)/2;
        }
        
        allDoctors.add(new Doctor((currRoom.xPos+this.xWidth)-(this.xWidth/2), (currRoom.yPos+this.yWidth)-(this.yWidth/2))); //adds a doctor to each room
      }
    
    }
  }
  
  //draws rooms and the walls around them
  void drawBuilding(){
    
    for (int i=0; i<this.numRooms; i++){
      Room currRoom = rooms.get(i);
      
      
      stroke(0);
      
      
      strokeWeight(5);
      fill(255);
      stroke(255);
      rect(currRoom.xPos, currRoom.yPos, this.xWidth, this.yWidth);
      
      
      fill(0);
      textAlign(CENTER,CENTER);
      textSize(30);
      
      
      
      stroke(0);
      strokeWeight(1);
      if (i%2==0){
        //these are to split the lines along the side of the room, making a gap
        line(currRoom.xPos+this.xWidth+2, currRoom.yPos,currRoom.xPos+this.xWidth+2,currRoom.yPos+(this.yWidth-this.doorWidth)/2.0);
        line(currRoom.xPos+this.xWidth+2, currRoom.yPos+(this.yWidth-this.doorWidth)/2.0 + this.doorWidth,currRoom.xPos+this.xWidth+2,currRoom.yPos+this.yWidth);
        
        fill(0);
        textAlign(CENTER,CENTER);
        textSize(30);
        text(str(int(allDoctors.get(i).doctorSkill)),allDoctors.get(i).xPos-20,allDoctors.get(i).yPos-5);
      }
      else{
        line(currRoom.xPos-2,currRoom.yPos,currRoom.xPos-2,currRoom.yPos+(this.yWidth-this.doorWidth)/2.0);
        line(currRoom.xPos-2,currRoom.yPos+(this.yWidth-this.doorWidth)/2.0+this.doorWidth,currRoom.xPos-2,currRoom.yPos+this.yWidth);
        
        fill(0);
        textAlign(CENTER,CENTER);
        textSize(30);
        text(str(int(allDoctors.get(i).doctorSkill)),allDoctors.get(i).xPos+20,allDoctors.get(i).yPos-5);
      }
      
      strokeWeight(5);
      
      stroke(0);
      line(currRoom.xPos,currRoom.yPos,currRoom.xPos+this.xWidth,currRoom.yPos);
      line(currRoom.xPos ,currRoom.yPos+this.yWidth , currRoom.xPos+this.xWidth ,currRoom.yPos+yWidth);
      
      strokeWeight(0);
      
      
    }
  }
  
}
