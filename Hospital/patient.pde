class Patient {
  int timeSinceEntered; 
  int treatmentTime;
  
  float injurySeverity;
  color patientColor;
  
  boolean isDead;
  boolean isHealthy;
  boolean isSeated;
  boolean reachedDoctor;
  
  int chairIndex;
  boolean searchingLeft;
  boolean hasSeat;
  boolean samexWithSeat;
  boolean reachedChairY;
  boolean reachedSeat;
  
  float patientX;
  float patientY;
  
 
  
  Doctor currentDoctor;
  
   //constructor
  Patient(int tSE, int tT, float iS, boolean iD, boolean iH, boolean ss, float pX, float pY) {
    this.timeSinceEntered = tSE;  
    this.treatmentTime = tT;
    this.injurySeverity = iS; //please limit between 0 & 100
    this.isDead = iD;   
    this.isHealthy = iH;
    this.isSeated = ss;
    this.patientX = pX;
    this.patientY = pY;
    this.reachedDoctor = false;
    this.currentDoctor = null;
    this.chairIndex=-1;
    this.hasSeat=false;
    this.samexWithSeat=false;
    this.reachedChairY=false;
    this.reachedSeat=false;
    
    this.updateColor();
    
    if (random(1)<0.5){
      searchingLeft=true;
    }
    else{
      searchingLeft=false;
    }
    
  }
  
  void updateColor(){
    if (injurySeverity<=50){
      this.patientColor = color(injurySeverity/50.0*255,255,0);
    }
    else{
      this.patientColor = color(255, (100-injurySeverity)/50.0*255,0);
    }
    if(this.injurySeverity==0 && this.isHealthy==false){
      this.isHealthy = true;
      this.currentDoctor.currentPatient=null;
      this.currentDoctor=null;
      
      //println("is healthy");
    }
  }
  
  void drawPa(){
    fill(patientColor);
    circle(patientX,patientY,15);
  }

}
