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
    this.doctorSkill = 5;
    this.doctorSpeed = 1;
    this.doctorColor = color(0, 0, 255);
    this.xPos = x;
    this.yPos = y;
    this.currentPatient = null;
  }
 
 
 //methods 
 //Heals patients
  void healPatient(){
    
    //Sets doctor speed to value on slider
    this.doctorSpeed = doctor_Speed.getValueF();
     
     //Calculates amount patient is healed 
     float healSpeed = (this.doctorSpeed/10)*2;
    
     currentPatient.injurySeverity -= healSpeed;
     
     //Probability of doctor healing patient
     if ((10-doctorSkill)/100 > random(0,1) && frameCount%5==0){ //so a doctor with 0 skill will have 1/10 chance of injuring patient
       this.currentPatient.injurySeverity+=20;
     }
   
 
  }
 
 //Draws doctors as circles
  void drawDr(){
    fill(doctorColor);
    circle(this.xPos, this.yPos, 15);

  }
 
 
}
