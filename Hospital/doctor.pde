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
    currentPatient.injurySeverity -= 1;
  }
 
  void drawDr(){
    fill(doctorColor);
    circle(this.xPos, this.yPos, 15);
    noStroke();
  }
 
 
}
