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
    this.doctorSkill = doctor_Skill.getValueF();
    this.doctorSpeed = doctor_Speed.getValueF();
    
    float healSpeed = (this.doctorSpeed/10)*2;
    
    //println(this.doctorSkill, currentPatient.injurySeverity);
    
    //if(this.doctorSkill/10 >= currentPatient.injurySeverity/100){
      currentPatient.injurySeverity -= healSpeed;
    //}
    /*else{
      if(currentPatient.injurySeverity < 100){
        currentPatient.injurySeverity += healSpeed;
      }
      else if(currentPatient.injurySeverity >= 100){
        currentPatient.patientColor = color(0);
        currentPatient.patientY--;
        
      }
    }*/
  }
 
  void drawDr(){
    fill(doctorColor);
    circle(this.xPos, this.yPos, 15);
    noStroke();
  }
 
 
}
