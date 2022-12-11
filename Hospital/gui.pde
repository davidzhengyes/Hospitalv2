/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:233619:
  appc.background(230);
} //_CODE_:window1:233619:

public void doctor_Skill_Slider(GCustomSlider source, GEvent event) { //_CODE_:doctor_Skill:394406:
  allDoctors.get(0).doctorSkill = doctor_Skill.getValueF();
} //_CODE_:doctor_Skill:394406:

public void doctor_Speed_Slider(GCustomSlider source, GEvent event) { //_CODE_:doctor_Speed:501818:
  allDoctors.get(0).doctorSpeed = doctor_Speed.getValueF();
} //_CODE_:doctor_Speed:501818:

public void num_Docotor_Changer(GTextField source, GEvent event) { //_CODE_:num_Doctor:501931:

  if (int(num_Doctor.getText())>36){
    building.numRooms = 36;
  }
 
  if (int(num_Doctor.getText())!=0 && int(num_Doctor.getText())<=36){
    reset();
    building.numRooms = int(num_Doctor.getText());
  }
  
  building.createBuilding();
} //_CODE_:num_Doctor:501931:

public void patient_Influx_Slider(GCustomSlider source, GEvent event) { //_CODE_:patient_Influx:524675:
  influx = 41-patient_Influx.getValueI();
} //_CODE_:patient_Influx:524675:

public void prioritize_Injuries_Checkbox(GCheckbox source, GEvent event) { //_CODE_:prioritize_Injuries:520254:
  if (prioritize_Injuries.isSelected()==true){
  prioritizeInjury=true;
  }
  else{
    prioritizeInjury=false;
  }
} //_CODE_:prioritize_Injuries:520254:

public void patient_Speed_Slider(GCustomSlider source, GEvent event) { //_CODE_:Sim_Speed:382723:
  frameRate(Sim_Speed.getValueF());
} //_CODE_:Sim_Speed:382723:

public void doctor_skill_range_slider(GCustomSlider source, GEvent event) { //_CODE_:doctor_range:380595:
  println("doctor_range - GCustomSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:doctor_range:380595:

public void injury_coefficient_slider(GCustomSlider source, GEvent event) { //_CODE_:injury_coefficient:903659:
  injuryCoeff=injury_coefficient.getValueI();
} //_CODE_:injury_coefficient:903659:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  window1 = GWindow.getWindow(this, "Window title", 0, 0, 500, 500, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  doctor_Skill = new GCustomSlider(window1, 20, 20, 120, 60, "purple18px");
  doctor_Skill.setShowValue(true);
  doctor_Skill.setShowLimits(true);
  doctor_Skill.setLimits(5, 1, 10);
  doctor_Skill.setNbrTicks(10);
  doctor_Skill.setStickToTicks(true);
  doctor_Skill.setShowTicks(true);
  doctor_Skill.setNumberFormat(G4P.INTEGER, 0);
  doctor_Skill.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  doctor_Skill.setOpaque(true);
  doctor_Skill.addEventHandler(this, "doctor_Skill_Slider");
  label1 = new GLabel(window1, 20, 0, 120, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Doctor Skill");
  label1.setOpaque(false);
  doctor_Speed = new GCustomSlider(window1, 160, 20, 120, 60, "purple18px");
  doctor_Speed.setShowValue(true);
  doctor_Speed.setShowLimits(true);
  doctor_Speed.setLimits(5, 1, 10);
  doctor_Speed.setNbrTicks(10);
  doctor_Speed.setStickToTicks(true);
  doctor_Speed.setShowTicks(true);
  doctor_Speed.setNumberFormat(G4P.INTEGER, 0);
  doctor_Speed.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  doctor_Speed.setOpaque(true);
  doctor_Speed.addEventHandler(this, "doctor_Speed_Slider");
  label2 = new GLabel(window1, 160, 0, 120, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Doctor Heal Speed");
  label2.setOpaque(false);
  label3 = new GLabel(window1, 300, 0, 120, 20);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("Num of Doctors");
  label3.setOpaque(false);
  num_Doctor = new GTextField(window1, 300, 20, 120, 60, G4P.SCROLLBARS_NONE);
  num_Doctor.setPromptText("Enter a Number");
  num_Doctor.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  num_Doctor.setOpaque(true);
  num_Doctor.addEventHandler(this, "num_Docotor_Changer");
  patient_Influx = new GCustomSlider(window1, 160, 180, 120, 60, "purple18px");
  patient_Influx.setShowValue(true);
  patient_Influx.setShowLimits(true);
  patient_Influx.setLimits(10, 1, 40);
  patient_Influx.setNbrTicks(10);
  patient_Influx.setStickToTicks(true);
  patient_Influx.setShowTicks(true);
  patient_Influx.setNumberFormat(G4P.INTEGER, 0);
  patient_Influx.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  patient_Influx.setOpaque(true);
  patient_Influx.addEventHandler(this, "patient_Influx_Slider");
  label4 = new GLabel(window1, 160, 160, 120, 20);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("Patient Influx");
  label4.setOpaque(false);
  prioritize_Injuries = new GCheckbox(window1, 300, 100, 120, 60);
  prioritize_Injuries.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  prioritize_Injuries.setText("Prioritize Injuries?");
  prioritize_Injuries.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  prioritize_Injuries.setOpaque(true);
  prioritize_Injuries.addEventHandler(this, "prioritize_Injuries_Checkbox");
  Sim_Speed = new GCustomSlider(window1, 160, 100, 120, 60, "purple18px");
  Sim_Speed.setShowValue(true);
  Sim_Speed.setShowLimits(true);
  Sim_Speed.setLimits(60, 10, 100);
  Sim_Speed.setNbrTicks(10);
  Sim_Speed.setStickToTicks(true);
  Sim_Speed.setShowTicks(true);
  Sim_Speed.setNumberFormat(G4P.INTEGER, 0);
  Sim_Speed.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  Sim_Speed.setOpaque(true);
  Sim_Speed.addEventHandler(this, "patient_Speed_Slider");
  label5 = new GLabel(window1, 160, 80, 120, 20);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("Simulation Speed");
  label5.setOpaque(false);
  doctor_range = new GCustomSlider(window1, 17, 100, 120, 60, "purple18px");
  doctor_range.setShowValue(true);
  doctor_range.setShowLimits(true);
  doctor_range.setLimits(1, 1, 5);
  doctor_range.setNbrTicks(5);
  doctor_range.setStickToTicks(true);
  doctor_range.setShowTicks(true);
  doctor_range.setNumberFormat(G4P.INTEGER, 0);
  doctor_range.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  doctor_range.setOpaque(true);
  doctor_range.addEventHandler(this, "doctor_skill_range_slider");
  label7 = new GLabel(window1, 20, 80, 120, 20);
  label7.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label7.setText("Doctor Skill Range");
  label7.setOpaque(false);
  injury_coefficient = new GCustomSlider(window1, 20, 180, 120, 60, "purple18px");
  injury_coefficient.setShowValue(true);
  injury_coefficient.setShowLimits(true);
  injury_coefficient.setLimits(5, 0, 10);
  injury_coefficient.setNbrTicks(11);
  injury_coefficient.setStickToTicks(true);
  injury_coefficient.setShowTicks(true);
  injury_coefficient.setNumberFormat(G4P.INTEGER, 0);
  injury_coefficient.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  injury_coefficient.setOpaque(true);
  injury_coefficient.addEventHandler(this, "injury_coefficient_slider");
  label6 = new GLabel(window1, 20, 160, 120, 20);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("Injury Coefficient");
  label6.setOpaque(false);
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GCustomSlider doctor_Skill; 
GLabel label1; 
GCustomSlider doctor_Speed; 
GLabel label2; 
GLabel label3; 
GTextField num_Doctor; 
GCustomSlider patient_Influx; 
GLabel label4; 
GCheckbox prioritize_Injuries; 
GCustomSlider Sim_Speed; 
GLabel label5; 
GCustomSlider doctor_range; 
GLabel label7; 
GCustomSlider injury_coefficient; 
GLabel label6; 
