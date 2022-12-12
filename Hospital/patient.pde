class Patient {
  //fields
  
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
  
  int enterTime;
  int treatmentTime;
  
  Doctor currentDoctor;
  
  //constructor
  Patient( float iS, boolean iH, boolean ss, float pX, float pY) {
    
   
    this.injurySeverity = iS; //please limit between 0 & 100
    
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
    this.enterTime=frameCount;
    
    this.updateColor();
    
    if (random(1)<0.5){
      searchingLeft=true;
    }
    else{
      searchingLeft=false;
    }
    
  }
  
  //methods
  
  //sets colour based on injury severity, from 0-50 red is being increased, and 50-100 green gets decreased.
  void updateColor(){
    if (injurySeverity<=50 && injurySeverity < 100){
      this.patientColor = color(injurySeverity/50.0*255,255,0);
    }
    else if (injurySeverity>=100){
      //if injury severity is greater than 100, add them to deadpatient list and unassign doctor and their patient
      deadP.add(new DeadPatient(int(this.patientX),int(this.patientY)));
      if(this.currentDoctor!=null){
        this.currentDoctor.currentPatient=null;
        this.currentDoctor=null;
      }
      //removes the patient and changes statistics
      allPatients.remove(this);
      totalDead++;
      treatedPatients++;
      totalTreatmentTime+=(frameCount-this.enterTime);
    }
    else{
      this.patientColor = color(255, (100-injurySeverity)/50.0*255,0);
    }
    //if they are healed remove them from doctor and make them healthy
    if(this.injurySeverity <= 0 && this.isHealthy==false &&this.currentDoctor!=null){
      treatedPatients++;
      totalTreatmentTime+=(frameCount-this.enterTime);
      this.isHealthy = true;
      this.currentDoctor.currentPatient=null;
      this.currentDoctor=null;

    }
  }
  
  //If the patient doesn't have a doctors, the patients injury will get worse
  void updateSeverity(){
    if (this.currentDoctor==null){
      
      this.injurySeverity += (pow(1.0005+0.0001*(injuryCoeff-5),this.injurySeverity/2)-1); //more severe injuries will progress faster
    }
  }
  
  //Draws patients
  void drawPa(){
    fill(patientColor);
    circle(patientX,patientY,15);
  }
  
 

}
