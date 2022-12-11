class Doctor {
 //fields
 float doctorSkill;
 float doctorSpeed;
 color doctorColor;
 int xPos;
 int yPos;
 
 
  Patient currentPatient;
 
 //constructor
  Doctor(int x, int y){
    this.doctorSkill = 1;
    this.doctorSpeed = 1;
    this.doctorColor = color(0, 0, 255);
    this.xPos = x;
    this.yPos = y;
    this.currentPatient = null;
  }
 
 
 //methods 
  void healPatient(){
    
    this.doctorSpeed = doctor_Speed.getValueF();
    
    float healSpeed = (this.doctorSpeed/10)*2;
    
    
      currentPatient.injurySeverity -= healSpeed;
      
     if ((10-doctorSkill)/100 > random(0,1) && frameCount%5==0){ //so a doctor with 0 skill will have 1/10 chance of injuring patient
       this.currentPatient.injurySeverity+=20;
     }
   
 
  }
 
  void drawDr(){
    fill(doctorColor);
    circle(this.xPos, this.yPos, 15);
    noStroke();
  }
 
 
}
