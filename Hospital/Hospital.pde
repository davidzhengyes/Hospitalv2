//Global Variables - Do not change
ArrayList<Doctor> allDoctors = new ArrayList<Doctor>();
ArrayList<Patient> allPatients = new ArrayList<Patient>();
ArrayList<DeadPatient> deadP = new ArrayList<DeadPatient>();
import g4p_controls.*;
PImage img;

ChairGrid cgLeft = new ChairGrid(50, 666, 12);
ChairGrid cgRight = new ChairGrid(370, 666, 12);

Boolean[] leftGrid = new Boolean[cgLeft.chairNum*2];
Boolean[] rightGrid = new Boolean [cgRight.chairNum*2];
Boolean prioritizeInjury=false;

int influx=20;
int injuryCoeff;
int avgInjury=5;
int injuryRange=10;
int lowerBound;
int upperBound;
int docSkill=5;
int docSkillRange=5;
int totalPatients=0;
int totalDead=0;
int treatedPatients=0;
int totalTreatmentTime;

Building building = new Building (4, 100, 600, 800, 20);

//Setup Function - draws basic hospital with rooms and waiting area and creates the GUI
void setup() {
  size(600, 800);

  createGUI();
  building.createBuilding();

  for (int i=0; i<leftGrid.length; i++) {
    leftGrid[i]=false;
    rightGrid[i]=false;
  }
}

//Draw Function
void draw() {
  //checks if there are seats available
  Boolean leftSeatAvailable = checkForOpenSeats(leftGrid);
  Boolean rightSeatAvailable = checkForOpenSeats(rightGrid);
  
  //manipulates upper and lower bounds of injury depending on slider values
  if(avgInjury*10-injuryRange*5<1){
    lowerBound=1;
  }
  else{
    lowerBound=avgInjury*10-injuryRange*5;
  }
  if (avgInjury*10+injuryRange*5>=99){
    upperBound=99;
  }
  else{
    upperBound=avgInjury*10+injuryRange*5; 
  }
 
  //makes a new patient and decides whether to add the patient to the screen or not depending on whether there are seats avaialble
  Patient newPatient = new Patient ( int(random(lowerBound, upperBound)), false, false, 300, 800);
  if (frameCount%influx==0 && (rightSeatAvailable && leftSeatAvailable)) {
    allPatients.add(newPatient);
    totalPatients++; //increases total patient count
  } else if (frameCount%influx==0 && (leftSeatAvailable)) {
    newPatient.searchingLeft=true;
    totalPatients++; //increases total patient count
    allPatients.add(newPatient);
  } else if (frameCount%influx==0 && rightSeatAvailable) {
    newPatient.searchingLeft=false;
    allPatients.add(newPatient);
    totalPatients++; //increases total patient count
  }
  
  //Redraws hospital graphics, live patients, doctors, dead patient markers and statistics each frame
  background(210);
  cgLeft.display();
  cgRight.display();
  building.drawBuilding();
  drawPercentageText();

  drawAverageTime();

  drawAllDead();
  
 
  //didn't use Doctor doctor:allDoctors as an iterator because of ConcurrentModificationException
  //loops through all doctors and draws them in rooms
  for (int i=0; i<allDoctors.size(); i++) {
    //in case number of doctors is changed while loop is running
    Doctor doctor;
    if(i<allDoctors.size()){
      doctor = allDoctors.get(i);
    }
    else{
      break;
    }


    doctor.drawDr();
    if (doctor.currentPatient == null) { //if the room is empty, as in there is no current patient
      
      if (!prioritizeInjury){
      //looping through all patients and seeing if they have a doctor. If they don't doctos are assigned patients and vice versa
        for (int g=0; g<allPatients.size(); g++) {
  
          //picks patient depending on how far up they are in the list of allPatients
          if (allPatients.get(g).currentDoctor == null && allPatients.get(g).isHealthy==false ) {
            allPatients.get(g).currentDoctor = doctor;
            doctor.currentPatient = allPatients.get(g);
  
            //setting the chair they were just in to be empty
            if (allPatients.get(g).searchingLeft==true && allPatients.get(g).chairIndex!=-1) {
              leftGrid[allPatients.get(g).chairIndex]=false;
            } 
            else if (allPatients.get(g).searchingLeft==false && allPatients.get(g).chairIndex!=-1) {
              rightGrid[allPatients.get(g).chairIndex]=false;
            }
  
  
            break;
          }
        }
      }
      else{
        //meaning if there is no available patient to choose from, that does not have a doctor
        //chooses most injured patient
        Patient mostInjuryPatient = checkMostInjured();
        if(mostInjuryPatient.injurySeverity!=-1){
          mostInjuryPatient.currentDoctor=doctor;
          doctor.currentPatient=mostInjuryPatient;
          
          //setting the chair they were just in to be empty
          if (mostInjuryPatient.searchingLeft==true && mostInjuryPatient.chairIndex!=-1) {
            leftGrid[mostInjuryPatient.chairIndex]=false;
          } 
          else if (mostInjuryPatient.searchingLeft==false && mostInjuryPatient.chairIndex!=-1) {
            rightGrid[mostInjuryPatient.chairIndex]=false;
          }
  
        }
        
        
      }
    } 
    //if the patient has a doctor they heal the patient
    else {
      if (doctor.currentPatient.reachedDoctor) {
        doctor.healPatient();
      }
    }
  }

  //not using Patient patient:allPatients same reason as doctors
  for (int i=0; i<allPatients.size(); i++) {
  //loops through all patients
    checktoDelete(); //checks whether or not they are off the screen to delete them
    
    Boolean[] gridToSearch;
    //little safeguard to prevent index out of range if allPatient array is suddenly changed
    Patient patient;
    if (i<allPatients.size()){
      patient = allPatients.get(i);
    }
    else{
      break;
    }
    
    
    
    //creates pointer to either left or right grid
    if (patient.searchingLeft==true && patient.chairIndex==-1) {
      gridToSearch=leftGrid;
    } 
    else {
      gridToSearch=rightGrid;
    }

    //checks if they don't have a chair nor a doctor, then assigns them to a chair if it is empty
    if (patient.chairIndex==-1 && patient.currentDoctor==null) {

      for (int g=0; g<gridToSearch.length; g++) {
        //if left or right grid [g] is false, make it true, set chair index to g, break loop
        if (gridToSearch[g]==false) {
          gridToSearch[g]=true; //WOW UTILIZING POINTER ARRAY HOPE IT WORKS :D
          patient.chairIndex=g;
          patient.hasSeat=true;
          break;
        }
      }
    }

 
    //updates colour depending on severity, and updates severity based on injury coefficient slider
    patient.updateColor();
    patient.updateSeverity();


    if (patient.isHealthy == false) { //if patient is not fully healed
      patient.drawPa();

      
      //move to enter hallway,once same height as doctor enters treatment room
      if (patient.currentDoctor != null) {
        if (patient.patientX == building.pathWidth/2 + building.xWidth || patient.patientY < 550) {
          if (patient.patientY == patient.currentDoctor.yPos) {
            //if patient same height as doctor
            if (abs(patient.patientX - patient.currentDoctor.xPos)==15) {
              patient.reachedDoctor = true;
            }
            if (patient.patientX < patient.currentDoctor.xPos && patient.reachedDoctor == false) {
              patient.patientX++;
            } 
            else if (patient.patientX > patient.currentDoctor.xPos && patient.reachedDoctor == false) {
              patient.patientX--;
            }
          } 
          else {
            //if not at same height as doctor keep going up
            patient.patientY--;
          }
        } 
        //movement out of seats toward doctor, depends if they are in upper or lower row
        else {
          if (patient.chairIndex<12) {
            if (patient.patientY > 550) {
              if (patient.patientY > 565) {
                patient.patientY--;
              } 
              else if (patient.patientX > 300 ) {
                patient.patientX--;
              } 
              else if (patient.patientX < 300) {
                patient.patientX++;
              }
            }
          } 
          else if (patient.chairIndex>11) {
            if (patient.patientY > 550) {
              if (patient.patientY < 700) {
                patient.patientY++;
              } 
              else if (patient.patientX > 300 ) {
                patient.patientX--;
              } 
              else if (patient.patientX < 300) {
                patient.patientX++;
              }
            }
          }
        }
      } 
      else { //those who do not have a doctor, making them get seated
        if (patient.chairIndex<12) {
          if (patient.patientY==600) {
            patient.reachedChairY=true;
          }
          if (patient.reachedChairY) {

            if (patient.patientX==57+(patient.chairIndex%12)*15 || patient.patientX==377+(patient.chairIndex%12)*15) {
              patient.samexWithSeat=true;
            }

            if (patient.searchingLeft ==true && patient.samexWithSeat==false) {
              patient.patientX--;
            } 
            else if (patient.samexWithSeat && patient.patientY<cgLeft.middleYpos-8) {

              patient.patientY++;
            }

            if (patient.searchingLeft ==false && patient.samexWithSeat==false) {
              patient.patientX++;
            }
          } 
          else {
            patient.patientY--;
          }
        } 
        else if (patient.chairIndex>=12) { //same as above but for bottom left row
          if (patient.patientY==700) {
            patient.reachedChairY=true;
          }
          if (patient.reachedChairY) {
            if (patient.patientX==57+(patient.chairIndex%12)*15 || patient.patientX==377+(patient.chairIndex%12)*15) {
              patient.samexWithSeat=true;
            }

            if (patient.searchingLeft ==true && patient.samexWithSeat==false) {
              patient.patientX--;
            } 
            else if (patient.samexWithSeat && patient.patientY>cgLeft.middleYpos+8) {

              patient.patientY--;
            }

            if (patient.searchingLeft ==false && patient.samexWithSeat==false) {
              patient.patientX++;
            }
          } 
          else {
            patient.patientY--;
          }
        }
      }
    } 
    //after they are healthy get them out of the top of the building
    else if (patient.isHealthy == true) {
      patient.drawPa();
      
      //Enters hallway
      if (patient.patientX != building.pathWidth/2 + building.xWidth) {
        if (patient.patientX >300 ) {
          patient.patientX--;
        } 
        else if (patient.patientX < 300) {
          patient.patientX++;
        }
      } 
      else { //moves up and out of building
        patient.patientY--;
      }
    }
  }
}

//loops through a seating grid and seeing if they are empty or not
Boolean checkForOpenSeats(Boolean [] grid) {
  for (int i=0; i<leftGrid.length; i++) {
    if (grid[i]==false ) {
      return true;
    } else if (grid[i]==false) {
      return true;
    }
  }
  return false;
}

//Draws markers where patients have died
void drawAllDead(){
  for(DeadPatient dp:deadP){
    fill(0);
    circle(dp.xPos,dp.yPos,5);
  }
  
}

//Draws chance of death statistic at bottom of screen
void drawPercentageText(){
  textSize(40);
  if (totalPatients!=0){
    fill(255);
    textAlign(LEFT);
    text(str(round((float(totalDead)/totalPatients)*100))+"\u0025 "+"chance of death",50,720);
    
  }
}

int docLower;
int docUpper;
void updateAllSkill(){
  //checks bounds on doctor skill and making it random between bounds
  if(docSkill-docSkillRange<0){
    docLower=1;
  }
  else{
    docLower=docSkill-docSkillRange;
  }
  if (docSkill+docSkillRange>9){
    docUpper=10;
  }
  else{
    docUpper=docSkill+docSkillRange; 
  }
  
  for (int i=0;i<allDoctors.size();i++){
    allDoctors.get(i).doctorSkill=int(random(docLower,docUpper));
      
  }
 
}

Patient checkMostInjured(){
  //starting with reference patient, then comparing
  Patient maxInjured=new Patient ( -1, false, false, 300, 700);
  //making reference patient, making sure that they don't have a doctor already
  for (int i=0; i<allPatients.size();i++){
    if (allPatients.get(i).currentDoctor==null){
      maxInjured=allPatients.get(i);
      break;
    }
  }

  for(int i=0;i<allPatients.size();i++){
    if (allPatients.get(i).injurySeverity>maxInjured.injurySeverity && allPatients.get(i).currentDoctor==null){
      maxInjured=allPatients.get(i);
    }
  }
  return maxInjured;
}

//Checks if pateints have moved off of the screen, if so they are deleted
void checktoDelete() {
  for (int i=0; i<allPatients.size(); i++) {
    if (allPatients.get(i).patientY < 0) {
      allPatients.remove(i);
    }
  }
}

//Draws average treatment time statistic
void drawAverageTime(){
  textSize(40);
  if (treatedPatients!=0){
    fill(255);
    textAlign(LEFT);
    text("Average Treatment Time: "+str(totalTreatmentTime/treatedPatients),50,750);
  }
  
}

//clears everything and creates new building and grid
void reset() {
  noLoop();

  allDoctors = new ArrayList<Doctor>();
  allPatients = new ArrayList<Patient>();
  deadP = new ArrayList<DeadPatient>();
  building.createBuilding();


  for (int i=0; i<leftGrid.length; i++) {
    leftGrid[i]=false;
    rightGrid[i]=false;
  }
 

  loop();
}
