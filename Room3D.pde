import SimpleOpenNI.*;

import processing.opengl.*;
import java.awt.Robot;

import controlP5.*;

/**
*
* @author Moe
* @since         10 January 2012
* @version 0.5   (prerelease, version 5.0)
* Main class - uses SimpleOpenNI context wrapper to display 
*              skeletal frame of 1 or more users and perform tracking.
*            - uses openGL processing libraries to display character
*              in a interactive 3D environment.
*/

///////////////////////
//    KinectStuff    //
///////////////////////

SimpleOpenNI kinect;
PushGesture pg;
SwipeGesture sg;
PointDrawer pointDrawer;
XnVSessionManager sm;

//////////////////////
//    View stuff    //
//////////////////////

Navi navi;
float floorLevel = 500.0f;

//////////////////
//    Player    //
//////////////////

float[] eye;
float xangle, yangle;

///////////////////
//    GLStuff    //
///////////////////

GLGrid myGrid;
GLElongatedCube myLink;

int sliderValue = 100;

//distance values
float neckToTorso, rightShoulderToElbow, leftShoulderToElbow;

public void setup() {

  size(800, 600, OPENGL);

  //set the projection matrix to perspective
  perspective(45, float(width)/float(height), 1, 500);

  strokeWeight(1);
  smooth();

  background(0);
  noCursor();
  
  //----------Camera Stuff----------//
  
  eye=new float[3];
  eye[0]= 3;
  eye[1]= -5;
  eye[2]= 0;
  xangle=0.0f;
  yangle=0.0f;
  
  navi=new Navi();
  navi.setCamera(eye, 90, 180);

  myGrid = new GLGrid(-30, 30, -30, 30, 1, new Color(60,80,150));
  myGrid.setStroked(true);
  
  myLink = new GLElongatedCube(100,100);
  myLink.setStroked(true);

 //----------Kinect Stuff----------//
 
  kinect = new SimpleOpenNI(this);
  
  kinect.setMirror(false);

  kinect.enableDepth();                              // enable depthMap generation 
  kinect.enableGesture ();                           // enable gesture detection
  kinect.enableHands();                              // enable hands
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);  // enable skeleton generation for all joints
  
  sm = kinect.createSessionManager("Click,Wave","RaiseHand");
  pg = new PushGesture();
  sg = new SwipeGesture();
  pointDrawer = new PointDrawer();

  sm.AddListener(pg);
  sm.AddListener(sg);
  sm.AddListener(pointDrawer);
}

float t;

public void draw() {

  background(0, 0, 0);
  
    lights();
    myGrid.display();
    pushMatrix();
      translate(0,0,0);
      myLink.display();
    popMatrix();

    camera(navi.eye[0], navi.eye[1], navi.eye[2], 
         navi.look[0], navi.look[1], navi.look[2], 
         navi.up[0], navi.up[01], navi.up[2]);
         
//         System.out.println("eye position on the x y and z axis");
//         print("x eye: " + navi.eye[0]);
//         print("y eye: " + navi.eye[1]);
//         print("z eye: " + navi.eye[2]);
//         System.out.println("");
//         System.out.println("look vector on the x y and z axis");
//         print("x look: " + navi.look[0]);
//         print("y look: " + navi.look[1]);
//         print("z look: " + navi.look[2]);
         
  // update the camera
  kinect.update();
  kinect.update(sm);
  pointDrawer.draw();
  
  // for all users from 1 to 10
  int i;
  for (i=1; i<=10; i++)
  {
    // check if the skeleton is being tracked
    if (kinect.isTrackingSkeleton(i))
    { 
      drawPoints(i);
      // draw a circle for a head 
      circleForAHead(i);
    }
  }
}

void mouseDragged()
{
  xangle=map(mouseX, 0, width, 0, 360);
  yangle=map(mouseY, 0, height, 0, 180);
  navi.setCamera(navi.getEye(), yangle, xangle);
}

void mouseReleased()
{
  xangle=180.0f;
  yangle=90.0f;
  navi.setCamera(navi.getEye(), yangle, xangle);
}


public void keyPressed(KeyEvent e)
{
  if (KeyEvent.getKeyText(e.getKeyCode()).equals("Up"))
    navi.lookUp();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Down"))
    navi.lookDown();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Right"))
    navi.lookRight();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Left"))
    navi.lookLeft();
  else if (e.getKeyChar() == 'w')
    navi.moveForward();
  else if (e.getKeyChar() == 'a')
    navi.lookLeft();
  else if (e.getKeyChar() == 's')
    navi.moveBackward();
  else if (e.getKeyChar() == 'd')
    navi.lookRight();
}

public void keyTyped(KeyEvent e)
{
  if (e.getKeyChar() == '-')
    navi.moveUp();
  else if (e.getKeyChar() == '+')
    navi.moveDown();
}


//-------Kinect stuff--------//


void drawPoints(int userId)
{

  PVector head = new PVector();
  PVector neck = new PVector();
  PVector torso = new PVector();

  PVector leftShoulder = new PVector();
  PVector rightShoulder = new PVector();

  PVector leftHip = new PVector();
  PVector rightHip = new PVector();

  PVector leftElbow = new PVector();
  PVector rightElbow = new PVector();
  PVector leftHand = new PVector();
  PVector rightHand = new PVector();

  PVector leftKnee = new PVector();
  PVector rightKnee = new PVector();
  PVector leftFoot = new PVector();
  PVector rightFoot = new PVector();
     
  //position the joints
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, neck);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, torso);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, leftHip);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, leftKnee);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, rightKnee);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, leftFoot);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);

  // convert real world point to projective space
  PVector jointPos_neck = new PVector(); 
  kinect.convertRealWorldToProjective(neck, jointPos_neck);
 
  PVector jointPos_torso = new PVector(); 
  kinect.convertRealWorldToProjective(torso, jointPos_torso);
  
  PVector jointPos_leftShoulder = new PVector(); 
  kinect.convertRealWorldToProjective(leftShoulder, jointPos_leftShoulder);

  PVector jointPos_rightShoulder = new PVector(); 
  kinect.convertRealWorldToProjective(rightShoulder, jointPos_rightShoulder);
  
  PVector jointPos_leftElbow = new PVector(); 
  kinect.convertRealWorldToProjective(leftElbow, jointPos_leftElbow);
  
  PVector jointPos_rightElbow = new PVector(); 
  kinect.convertRealWorldToProjective(rightElbow, jointPos_rightElbow);
  
  PVector jointPos_leftHip = new PVector(); 
  kinect.convertRealWorldToProjective(leftHip, jointPos_leftHip);
  
  PVector jointPos_rightHip = new PVector(); 
  kinect.convertRealWorldToProjective(leftHip, jointPos_leftHip);
  
  PVector jointPos_leftKnee = new PVector(); 
  kinect.convertRealWorldToProjective(leftKnee, jointPos_leftKnee);
  
  PVector jointPos_rightKnee = new PVector(); 
  kinect.convertRealWorldToProjective(rightKnee, jointPos_rightKnee);
  
  PVector jointPos_leftFoot = new PVector(); 
  kinect.convertRealWorldToProjective(leftFoot, jointPos_leftFoot);
  
  PVector jointPos_rightFoot = new PVector(); 
  kinect.convertRealWorldToProjective(rightFoot, jointPos_rightFoot);
  
    //find the difference in distance between each joint
    neckToTorso = JointUtils.distance3D(jointPos_neck, jointPos_torso);
    rightShoulderToElbow = JointUtils.distance3D(jointPos_rightShoulder, jointPos_rightElbow);
    leftShoulderToElbow = JointUtils.distance3D(jointPos_leftShoulder, jointPos_leftElbow);
    
  // draw the joint spheres
  pushMatrix();
    translate(jointPos_neck.x/20, jointPos_neck.y/20, jointPos_neck.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_torso.x/20, jointPos_torso.y/20, jointPos_torso.z/500);
    sphere(.5);
    draw3DRect();  //need to specify length with the distance variable above? i need to pass it the draw3DRect() method
  popMatrix();
  
  pushMatrix();
    translate(jointPos_leftShoulder.x/20, jointPos_leftShoulder.y/20, jointPos_leftShoulder.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_rightShoulder.x/20, jointPos_rightShoulder.y/20, jointPos_rightShoulder.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_leftElbow.x/20, jointPos_leftElbow.y/20, jointPos_leftElbow.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_rightElbow.x/20, jointPos_rightElbow.y/20, jointPos_rightElbow.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_leftHip.x/20, jointPos_leftHip.y/20, jointPos_leftHip.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_rightHip.x/20, jointPos_rightHip.y/20, jointPos_rightHip.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_leftKnee.x/20, jointPos_leftKnee.y/20, jointPos_leftKnee.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_rightKnee.x/20, jointPos_rightKnee.y/20, jointPos_rightKnee.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_leftFoot.x/20, jointPos_leftFoot.y/20, jointPos_leftFoot.z/500);
    sphere(.5);
  popMatrix();
  
  pushMatrix();
    translate(jointPos_rightFoot.x/20, jointPos_rightFoot.y/20, jointPos_rightFoot.z/500);
    sphere(.5);
  popMatrix();
  
}

// gets the position of the specified joint and store it in the provided PVector
public void getJointProjective(int userId, int joint, PVector jointProj)
{
  PVector jointReal = new PVector();

  // retrieve joint position in real world
  kinect.getJointPositionSkeleton(userId, joint, jointReal);

  // convert from real world to projective
  kinect.convertRealWorldToProjective(jointReal, jointProj);
}

// draws a circle at the position of the head
public void circleForAHead(int userId)
{
  // get 3D position of a joint
  PVector jointPos = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos);
  
  // convert real world point to projective space
  PVector jointPos_Proj = new PVector(); 
  kinect.convertRealWorldToProjective(jointPos, jointPos_Proj);

  // create a distance scalar related to the depth (z dimension)
  float distanceScalar = (jointPos_Proj.z/500);

  // set the fill colour to make the circle green
  fill(60, 70, 150); 

  // draw the circle at the position of the head with the head size scaled by the distance scalar
  //sphere(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*headsize, distanceScalar*headsize);
  pushMatrix();
    translate(jointPos_Proj.x/20, jointPos_Proj.y/20, distanceScalar);
    sphere(2);
  popMatrix();
}

// draw the skeleton with the selected joints
public void drawSkeleton(int userId)
{  
  // draw limbs  
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

public void draw3DRect()
{
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL gl = pgl.beginGL();
  gl.glColor4f(0.7,0.7,0.7,0.8);
  gl.glTranslatef(0, 0, 0);           //translate rectangle to the origin
  gl.glRectf(-200,-200,200,200);
                                      //rotate rectangle into position according to respective joint
  pgl.endGL();
}





///////////////////////////////////
//      Event-based Methods      //
///////////////////////////////////

// when a person ('user') enters the field of view
void onNewUser(int userId)
{
  println("New User Detected - userId: " + userId);

  // start pose detection
  kinect.startPoseDetection("Psi", userId);
}

// when a person ('user') leaves the field of view 
void onLostUser(int userId)
{
  println("User Lost - userId: " + userId);
}

// when a user begins a pose
void onStartPose(String pose, int userId)
{
  println("Start of Pose Detected  - userId: " + userId + ", pose: " + pose);

  // stop pose detection
  kinect.stopPoseDetection(userId); 

  // start attempting to calibrate the skeleton
  kinect.requestCalibrationSkeleton(userId, true);
}

// when calibration begins
void onStartCalibration(int userId)
{
  println("Beginning Calibration - userId: " + userId);
}

// when calibaration ends - successfully or unsucessfully 
void onEndCalibration(int userId, boolean successfull)
{
  println("Calibration of userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");

    // begin skeleton tracking
    kinect.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");

    // Start pose detection
    kinect.startPoseDetection("Psi", userId);
  }
}

////////////////////////////////
//    Session-based events    //
////////////////////////////////

void onStartSession(PVector pos)
{
  println("onStartSession: " + pos);
  kinect.removeGesture("Click,Wave");
}

void onEndSession()
{
  println("onEndSession: ");
  kinect.addGesture("Click,Wave");
}

void onFocusSession(String strFocus, PVector pos, float progress)
{
  println("onFocusSession: focus=" + strFocus + ",pos=" + pos + ",progress=" + progress);
}

/////////////////////////////
//    Hand-based events    //
/////////////////////////////

void onCreateHands(int handId, PVector pos, float time)
{
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);
}

void onUpdateHands(int handId, PVector pos, float time)
{
  // println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
}

void onDestroyHands(int handId, float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
}

////////////////////////////////
//    Gesture-based events    //
////////////////////////////////

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + 
    ", idPosition: " + idPosition + ", endPosition:" + endPosition);
}

void onProgressGesture(String strGesture, PVector position, float progress)
{
  println("onProgressGesture - strGesture: " + strGesture + 
    ", position: " + position + ", progress:" + progress);
}

