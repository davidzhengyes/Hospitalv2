//Global Variables
ArrayList<Doctor> allDoctors = new ArrayList<Doctor>();
ArrayList<Patient> allPatients = new ArrayList<Patient>();
import g4p_controls.*;
PImage img;
//s
ChairGrid cgLeft = new ChairGrid(50,666,12);
ChairGrid cgRight = new ChairGrid(370,666,12);
Boolean[] leftGrid = new Boolean[cgLeft.chairNum*2];
Boolean[] rightGrid = new Boolean [cgRight.chairNum*2];
Boolean initialFill = false;


Building building = new Building (4,100,600,800,20);
void setup(){
  //img = loadImage ("yep.jpg");
  size(600,800);
  
 
  
  Patient ss = new Patient (0,0,99, false,false,false,300,700);
  allPatients.add(ss);
  
  createGUI();
  building.createBuilding();
  
  for (int i=0; i<leftGrid.length;i++){
    leftGrid[i]=false;
    rightGrid[i]=false;
  }

}


void draw(){
  Boolean leftSeatAvailable = checkForOpenSeats(leftGrid);
  Boolean rightSeatAvailable = checkForOpenSeats(rightGrid);
  Patient newPatient = new Patient (0,0,int(random(1,100)), false,false,false,300,800);
  if (frameCount%20==0 && (leftSeatAvailable && rightSeatAvailable) && initialFill==false){
    allPatients.add(newPatient);
  }
  
  if(!leftSeatAvailable || !rightSeatAvailable){
    initialFill=true;
    println(frameCount);
  }
  
  if (initialFill==true && leftSeatAvailable){
    newPatient.searchingLeft=true;
    allPatients.add(newPatient);
  }
  else if (initialFill=true && rightSeatAvailable){
    newPatient.searchingLeft=false;
    allPatients.add(newPatient);
  }

  background(210);
  cgLeft.display();
  cgRight.display();
  building.drawBuilding();
  
  //didn't use Doctor doctor:allDoctors as an iterator because of ConcurrentModificationException
  for(int i=0;i<allDoctors.size();i++){ 
    Doctor doctor = allDoctors.get(i);
    
    //randomly assigning patients to doctors;
    doctor.drawDr();
    if (doctor.currentPatient == null){ //if room is empty
      
      //looping through all patients and seeing if they dont have a doctor, and assigning them to each other
      for(int g=0; g<allPatients.size();g++){
        
      //pick random patient
        if (allPatients.get(g).currentDoctor == null){
          allPatients.get(g).currentDoctor = doctor;
          doctor.currentPatient = allPatients.get(g);
          break;
        //print(doctor.currentPatient.patientX);
        }
      }
    }
    
    else{
      if (doctor.currentPatient.reachedDoctor){
        doctor.healPatient();
      }
    }
  }
  
  //not using Patient patient:allPatients same reason as doctors
  for (int i=0; i<allPatients.size(); i++){
    
    checktoDelete();
    
    Boolean[] gridToSearch;
    Patient patient = allPatients.get(i);
    try{
      //println(allPatients.get(4).chairIndex);
    }
    catch(Exception e){
      
    }
    if (patient.searchingLeft==true && patient.chairIndex==-1){
      gridToSearch=leftGrid;
    }
    else{
      gridToSearch=rightGrid;
    }
   
   
    if (patient.chairIndex==-1 && patient.currentDoctor==null){ 
    
      for (int g=0; g<gridToSearch.length;g++){
        //if left or right grid [g] is false, make it true, set chair index to g, break loop
        if(gridToSearch[g]==false){
          gridToSearch[g]=true; //WOW UTILIZING POINTER ARRAY HOPE IT WORKS :D
          patient.chairIndex=g;
          patient.hasSeat=true;
          break;
        }
      }
    }
    
    //if(patient.chairIndex==-1 && patient.currentDoctor==null){
    //  for (int g=0;g<leftGrid.length;g++){
    //    if (patient.searchingLeft==true){
    //      if(leftGrid[g]==false){
            
    //        leftGrid[g]=true; 
    //        patient.chairIndex=g;
    //        patient.hasSeat=true;
    //        break;
    //      }
    //    }
    //    else{
          
    //    }
    //  }
    //}
    
    patient.updateColor();
    
    
    if(patient.isHealthy == false){//need if here, if patient is not already healed
      patient.drawPa();
      
      patient.timeSinceEntered++;
      
      if (patient.currentDoctor != null){
        
        if (patient.patientY == patient.currentDoctor.yPos){
          //if patient same height as doctor
          if (abs(patient.patientX - patient.currentDoctor.xPos)==15){
            patient.reachedDoctor = true;
          }
          if (patient.patientX < patient.currentDoctor.xPos && patient.reachedDoctor == false){
            patient.patientX++;
          }
          else if (patient.patientX > patient.currentDoctor.xPos && patient.reachedDoctor == false){
            patient.patientX--;
          }
          
          
        }
        else{
          //if not at same height keep going up
          patient.patientY--;
        }
        
      }
      else{ //those who do not have a doctor //edit here more for seating
        if (patient.chairIndex<12){
          if (patient.patientY==600){
            patient.reachedChairY=true;
          }
          if (patient.reachedChairY){
            
            if (patient.patientX==57+(patient.chairIndex%12)*15 || patient.patientX==377+(patient.chairIndex%12)*15){
              patient.samexWithSeat=true;
            }
            
            if (patient.searchingLeft ==true && patient.samexWithSeat==false){
              patient.patientX--;
            }
            else if (patient.samexWithSeat && patient.patientY<cgLeft.middleYpos-8){
              
              patient.patientY++;
            }
            
            if (patient.searchingLeft ==false && patient.samexWithSeat==false){
              patient.patientX++;
            }
            

          }
          else{
            patient.patientY--;
          }
        }
        else if (patient.chairIndex>=12){ //same as above but for bottom left row
          if (patient.patientY==700){
            patient.reachedChairY=true;
          }
          if(patient.reachedChairY){
            if (patient.patientX==57+(patient.chairIndex%12)*15 || patient.patientX==377+(patient.chairIndex%12)*15){
              patient.samexWithSeat=true;
            }
            
            if (patient.searchingLeft ==true && patient.samexWithSeat==false){
              patient.patientX--;
            }
            else if (patient.samexWithSeat && patient.patientY>cgLeft.middleYpos+8){
              
              patient.patientY--;
            }
            
            if (patient.searchingLeft ==false && patient.samexWithSeat==false){
              patient.patientX++;
            }

          }
          else{
            patient.patientY--;
          }
        }
      }
    }
    else if(patient.isHealthy == true){
      patient.drawPa();
      if (patient.patientX != building.pathWidth/2 + building.xWidth){
        if (patient.patientX < patient.currentDoctor.xPos && patient.reachedDoctor == true){
          patient.patientX--;
        }
        else if (patient.patientX > patient.currentDoctor.xPos && patient.reachedDoctor == true){
          patient.patientX++;
        }
      }
      else{
       patient.patientY--; 
      }
    }
  }
}


Boolean checkForOpenSeats(Boolean [] grid){
  for (int i=0;i<leftGrid.length;i++){
    if (grid[i]==false ){
      return true;
    }
    else if (grid[i]==false){
      return true;
    }
  }
  println(frameCount);
  return false;
  
}


void checktoDelete(){
  for(int i=0;i<allPatients.size();i++){
    if (allPatients.get(i).patientY<0){
      allPatients.remove(i);
    }
  }
}

void reset(){
  noLoop();
  allDoctors = new ArrayList<Doctor>();
  allPatients = new ArrayList<Patient>();
  building.createBuilding();
  allPatients.add(new Patient (0,0,99, false,false,false,300,700));
  
  for (int i=0; i<leftGrid.length;i++){
    leftGrid[i]=false;
    rightGrid[i]=false;
  }
  
  loop();
}
