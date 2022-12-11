//Global Variables
ArrayList<Doctor> allDoctors = new ArrayList<Doctor>();
ArrayList<Patient> allPatients = new ArrayList<Patient>();
ArrayList<DeadPatient> deadP = new ArrayList<DeadPatient>();
import g4p_controls.*;
PImage img;
//s
ChairGrid cgLeft = new ChairGrid(50, 666, 12);
ChairGrid cgRight = new ChairGrid(370, 666, 12);
Boolean[] leftGrid = new Boolean[cgLeft.chairNum*2];
Boolean[] rightGrid = new Boolean [cgRight.chairNum*2];
int influx=20;
Boolean prioritizeInjury=false;
int injuryCoeff;
int avgInjury=5;
int injuryRange=10;
int lowerBound;
int upperBound;
int docSkill=5;
int docSkillRange=5;
int totalPatients=0;
int totalDead=0;

Building building = new Building (4, 100, 600, 800, 20);
void setup() {
  //img = loadImage ("yep.jpg");
  size(600, 800);



  Patient ss = new Patient (0, 0, 99, false, false, false, 300, 700);
  allPatients.add(ss);

  createGUI();
  building.createBuilding();

  for (int i=0; i<leftGrid.length; i++) {
    leftGrid[i]=false;
    rightGrid[i]=false;
  }
}


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
 
  //makes a new patient and decides whether to add or not depending on whether there are seats avaialble, and increases total patient count.
  Patient newPatient = new Patient ( int(random(lowerBound, upperBound)), false, false, 300, 800);
  if (frameCount%influx==0 && (rightSeatAvailable && leftSeatAvailable)) {
    allPatients.add(newPatient);
    totalPatients++;
  } else if (frameCount%influx==0 && (leftSeatAvailable)) {
    newPatient.searchingLeft=true;
    totalPatients++;
    allPatients.add(newPatient);
  } else if (frameCount%influx==0 && rightSeatAvailable) {
    newPatient.searchingLeft=false;
    allPatients.add(newPatient);
    totalPatients++;
  }
  
  //draws everything
  background(210);
  cgLeft.display();
  cgRight.display();
  building.drawBuilding();
  drawPercentageText();
  drawAllDead();
  
 
  //didn't use Doctor doctor:allDoctors as an iterator because of ConcurrentModificationException
  //loops through doctors
  for (int i=0; i<allDoctors.size(); i++) {
    Doctor doctor = allDoctors.get(i);


    doctor.drawDr();
    if (doctor.currentPatient == null) { //if room is empty
      
      if (!prioritizeInjury){
      //looping through all patients and seeing if they dont have a doctor, and assigning them to each other
        for (int g=0; g<allPatients.size(); g++) {
  
          //pick patient depending on how far up they are in the list of allPatients
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
          
          if (mostInjuryPatient.searchingLeft==true && mostInjuryPatient.chairIndex!=-1) {
            leftGrid[mostInjuryPatient.chairIndex]=false;
          } 
          else if (mostInjuryPatient.searchingLeft==false && mostInjuryPatient.chairIndex!=-1) {
            rightGrid[mostInjuryPatient.chairIndex]=false;
          }
  
        }
        
        
      }
    } 
    //if patient has doctor, heal the patient
    else {
      if (doctor.currentPatient.reachedDoctor) {
        doctor.healPatient();
      }
    }
  }

  //not using Patient patient:allPatients same reason as doctors
  for (int i=0; i<allPatients.size(); i++) {
  //loops through all patients
    checktoDelete();

    Boolean[] gridToSearch;
    Patient patient = allPatients.get(i);

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


    if (patient.isHealthy == false) {//need if here, if patient is not already healed
      patient.drawPa();

      
        //movement for after they have a doctor
      if (patient.currentDoctor != null) {
        if (patient.patientX == building.pathWidth/2 + building.xWidth || patient.patientY < 500) {
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
            //if not at same height keep going up
            patient.patientY--;
          }
        } 
        //movement out of seats toward doctor, depends if they are in upper or lower row
        else {
          if (patient.chairIndex<12) {
            if (patient.patientY > 500) {
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
            if (patient.patientY > 500) {
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
      
      if (patient.patientX != building.pathWidth/2 + building.xWidth) {
        if (patient.patientX >300 ) {
          patient.patientX--;
        } 
        else if (patient.patientX < 300) {
          patient.patientX++;
        }
      } 
      else {
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

void drawAllDead(){
  for(DeadPatient dp:deadP){
    fill(0);
    circle(dp.xPos,dp.yPos,5);
  }
  
}

void drawPercentageText(){
  textSize(40);
  if (totalPatients!=0){
    text(str(round((float(totalDead)/totalPatients)*100))+"\u0025 "+"chance of death",100,700);
    
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

void checktoDelete() {
  for (int i=0; i<allPatients.size(); i++) {
    if (allPatients.get(i).patientY < 0) {
      allPatients.remove(i);
    }
  }
}

void reset() {
  noLoop();
  //clears everything and creates new building and grid
  allDoctors = new ArrayList<Doctor>();
  allPatients = new ArrayList<Patient>();
  building.createBuilding();


  for (int i=0; i<leftGrid.length; i++) {
    leftGrid[i]=false;
    rightGrid[i]=false;
  }

  loop();
}
