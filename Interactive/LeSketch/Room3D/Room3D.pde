import saito.objloader.*;

import SimpleOpenNI.*;

import processing.opengl.*;
import java.awt.Robot;
import java.util.Vector;

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
boolean collision;
boolean isTrackingHands;
boolean isPushRegistered;

PVector head, neck, torso, 
          leftShoulder, rightShoulder, 
          leftElbow, rightElbow,
          leftHand, rightHand, 
          leftHip, rightHip, 
          leftKnee, rightKnee, 
          leftFoot, rightFoot;

PVector handPosition;
ArrayList<PVector> handPositions;
PVector previousPos, currentPos;

//////////////////////////////
//      Physics stuff       //
//////////////////////////////

public static final int NUM_POSITIONS = 20;
protected PVector avgVelocity;
protected PVector avgSpeed;
public float speed;
public static final float X_THRESHOLD = 2.0f,
                          Y_THRESHOLD = 2.0f, 
                          Z_THRESHOLD = 2.0f;

//////////////////////
//    View stuff    //
//////////////////////

private Navi navi;
private float floorLevel = 500.0f;

//////////////////
//    Player    //
//////////////////

private float[] eye;
private float xangle, yangle;

///////////////////
//    GLStuff    //
///////////////////

GL gl;
GLGrid myGrid;
GLElongatedCube myLink;
JointUtils myJointUtils;
public Ball myBall;
private static final float COORDINATE_SCALING = 400.0f;
private float dt = 0.05f;

// declare the Icosahedron object
Icosahedron ico1;
Icosahedron ico2;

float ico1Size = 75;
float ico2Size = 50;

////////////////////////////
//    OBJ Parser Stuff    //
////////////////////////////

Vector<OBJModel> myEnvironmentModels;
Vector<OBJModel> myJointModels;

OBJModel mayaModel, mayaCube, mneck, mleftShoulder, mrightShoulder,      // joints
         mleftElbow, mrightElbow, mleftHand, mrightHand, mtorso,
         mleftHip, mrightHip, mleftKnee, mrightKnee;
         
OBJModel mBuildOne, mBuildTwo, mBuildThree, mBuildFour, mBuildFive,      // buildings
         mBuildSix;
         
OBJModel mTerrain, mRight, mLeft, mBack, mFront, mSky;                   // sky box

BoundingBox bbox;

//distance values
float neckToTorso, rightShoulderToElbow, leftShoulderToElbow;

public void setup() {

  size(800, 600, OPENGL);
  
  //reference GL object
  gl = ((PGraphicsOpenGL) g).gl;
  
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

  //----------Open GL Stuff---------//
  
  myGrid = new GLGrid(-40, 40, -40, 40, 1, new Color(60,80,150));
  myGrid.setStroked(true);
    
  myBall = new Ball(1.0f);
  myBall.setStroked(false);
  myBall.setPosition(0.0f, 0.0f, 0.0f);
  myBall.setTimeStep(this.dt);
  
    ico1 = new Icosahedron(ico1Size);  // create instance of ico1
  
  //--------OBJ Loader stuff-------//
  
  mayaCube = new OBJModel(this, "./data/cube.obj", "relative", TRIANGLES);
  mneck = new OBJModel(this, "./data/joints/neck.obj", "relative", QUADS);
  mleftShoulder = new OBJModel(this, "./data/joints/leftShoulder.obj", "relative", QUADS);
  mrightShoulder = new OBJModel(this, "./data/joints/rightShoulder.obj", "relative", QUADS);
  mrightElbow = new OBJModel(this, "./data/joints/rightElbow.obj", "relative", QUADS);
  mleftElbow = new OBJModel(this, "./data/joints/leftElbow.obj", "relative", QUADS);
  mleftHand = new OBJModel(this, "./data/joints/leftHand.obj", "relative", QUADS);
  mrightHand = new OBJModel(this, "./data/joints/rightHand.obj", "relative", QUADS);
  mtorso = new OBJModel(this, "./data/joints/torso.obj", "relative", QUADS);
  mleftHip = new OBJModel(this, "./data/joints/leftHip.obj", "relative", QUADS);
  mrightHip = new OBJModel(this, "./data/joints/rightHip.obj", "relative", QUADS);
  mrightKnee = new OBJModel(this, "./data/joints/rightKnee.obj", "relative", QUADS);
  mleftKnee = new OBJModel(this, "./data/joints/leftKnee.obj", "relative", QUADS);
  
  myJointModels = new Vector<OBJModel>();
  myJointModels.addElement(mayaCube);
  myJointModels.addElement(mneck);
  myJointModels.addElement(mleftShoulder);
  myJointModels.addElement(mrightShoulder);
  myJointModels.addElement(mtorso);
  myJointModels.addElement(mleftHand);
  myJointModels.addElement(mrightHand);
  myJointModels.addElement(mleftHip);
  myJointModels.addElement(mrightHip);
  myJointModels.addElement(mleftKnee);
  myJointModels.addElement(mrightKnee);
  
  myEnvironmentModels = new Vector<OBJModel>();
//  mTerrain = new OBJModel(this, "data/environment/skybox/scene.obj", "relative", TRIANGLES);
//  mTerrain.disableDebug();
//  
//  myEnvironmentModels.add(mTerrain);
  
  //----------Kinect Stuff----------//
 
  kinect = new SimpleOpenNI(this);
  
  kinect.setMirror(false);
  isTrackingHands = false;
  
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
  
  myJointUtils = new JointUtils();
}

public void draw() {

  background(0, 0, 0);
  
   lights();
   
   pushMatrix();
     translate(80, 50, 0);
     pointLight(51, 102, 126, 35, 40, 36);
   popMatrix();

    
    camera(navi.eye[0], navi.eye[1], navi.eye[2], 
         navi.look[0], navi.look[1], navi.look[2], 
         navi.up[0], navi.up[01], navi.up[2]);
      
      myGrid.display();
      
      pushStyle();
        fill(80, 240,140);
        myBall.display();   
      popStyle();
      
  // update the camera
  kinect.update();
  kinect.update(sm);
  
  // draw maya models
//  for(OBJModel model : myEnvironmentModels)
//    model.draw();
    
  // for all users from 1 to 10
  int i;
  for (i=1; i<=10; i++)
  {
    // check if the skeleton is being tracked
    if (kinect.isTrackingSkeleton(i))
    { 
      drawPoints(i);           // draw cubes for the skeleton
      circleForAHead(i);       // draw a circle for a head
    }
    if(isPushRegistered)
       myBall.move(); 
  }

  
  if(isTrackingHands)
  {
      if(speed > 4.0f)
      { 
        myBall.setStroked(false);
      
      } else {
        myBall.setPosition(handPosition.x, handPosition.y, handPosition.z);
        //myBall.setPosition(handPos[0], handPos[1], handPos[2]);
        myBall.setStroked(false);
        myBall.setAcceleration(0.0f, 0.0f, 0.0f);
      }
  }

// TEST CODE FOR JOINT ROTATION // 

//  PVector testJoint1, testJoint2;
//  
//  testJoint1 = new PVector();
//  testJoint1.x = 0.0f;
//  testJoint1.y = 0.0f;
//  testJoint1.z = 0.0f;
//  
//  testJoint2 = new PVector();
//  testJoint2.x = 0.0f;
//  testJoint2.y = 2.0f;
//  testJoint2.z = -2.0f;
//  
//  float[] m = new float[3];
//  m = JointUtils.calcJointRotation(testJoint1, testJoint2);
//  gl.glMultMatrixf(m,0); 
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
  //reference GL object
  gl = ((PGraphicsOpenGL) g).gl;
  
  head = new PVector();
  neck = new PVector();
  torso = new PVector();

  leftShoulder = new PVector();
  rightShoulder = new PVector();

  leftHip = new PVector();
  rightHip = new PVector();

  leftElbow = new PVector();
  rightElbow = new PVector();
  leftHand = new PVector();
  rightHand = new PVector();

  leftKnee = new PVector();
  rightKnee = new PVector();
  leftFoot = new PVector();
  rightFoot = new PVector();
     
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
  PVector jointPos_leftHand = new PVector(); 
  kinect.convertRealWorldToProjective(leftHand, jointPos_leftHand);
  PVector jointPos_rightHand = new PVector(); 
  kinect.convertRealWorldToProjective(rightHand, jointPos_rightHand);
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
    
  // draw the joint spheres
  pushMatrix();
//    translate(jointPos_neck.x/20, jointPos_neck.y/20, jointPos_neck.z/500);
//    scale(1,2.5,1);
    gl.glTranslatef(jointPos_neck.x/20, jointPos_neck.y/20, jointPos_neck.z/500);
    gl.glScalef(1.0f, 2.5f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
//    translate(jointPos_torso.x/20, jointPos_torso.y/20, jointPos_torso.z/500);
//    scale(1,2,1);
    gl.glTranslatef(jointPos_torso.x/20, jointPos_torso.y/20, jointPos_torso.z/500);
    gl.glScalef(1.0f, 2.0f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
//    translate(jointPos_leftShoulder.x/20, jointPos_leftShoulder.y/20, jointPos_leftShoulder.z/500);
//    scale(1,2,1);
    gl.glTranslatef(jointPos_leftShoulder.x/20, jointPos_leftShoulder.y/20, jointPos_leftShoulder.z/500);
    gl.glScalef(1.0f,2.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
//    translate(jointPos_rightShoulder.x/20, jointPos_rightShoulder.y/20, jointPos_rightShoulder.z/500);
//    scale(1,2,1);
    gl.glTranslatef(jointPos_rightShoulder.x/20, jointPos_rightShoulder.y/20, jointPos_rightShoulder.z/500);
    gl.glScalef(1.0f, 2.0f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
//    translate(jointPos_leftElbow.x/20, jointPos_leftElbow.y/20, jointPos_leftElbow.z/500);
//    scale(1,2.5,1);
    gl.glTranslatef(jointPos_leftElbow.x/20, jointPos_leftElbow.y/20, jointPos_leftElbow.z/500);
    gl.glScalef(1.0f, 2.5f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
//    translate(jointPos_rightElbow.x/20, jointPos_rightElbow.y/20, jointPos_rightElbow.z/500);
//    scale(1,2.5,1);
    gl.glTranslatef(jointPos_rightElbow.x/20, jointPos_rightElbow.y/20, jointPos_rightElbow.z/500);
    gl.glScalef(1.0f ,2.5f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_leftHand.x/20, jointPos_leftHand.y/20, jointPos_leftHand.z/500);
    gl.glScalef(1.0f,1.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_rightHand.x/20, jointPos_rightHand.y/20, jointPos_rightHand.z/500);
    gl.glScalef(1.0f,1.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_leftHip.x/20, jointPos_leftHip.y/20, jointPos_leftHip.z/500);
    gl.glScalef(1.0f,2.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_rightHip.x/20, jointPos_rightHip.y/20, jointPos_rightHip.z/500);
    gl.glScalef(1.0f,2.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_leftKnee.x/20, jointPos_leftKnee.y/20, jointPos_leftKnee.z/500);
    gl.glScalef(1.0f,2.5f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_rightKnee.x/20, jointPos_rightKnee.y/20, jointPos_rightKnee.z/500);
    gl.glScalef(1.0f,2.5f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_leftFoot.x/20, jointPos_leftFoot.y/20, jointPos_leftFoot.z/500);
    gl.glScalef(1.0f,1.0f,1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  pushMatrix();
    gl.glTranslatef(jointPos_rightFoot.x/20, jointPos_rightFoot.y/20, jointPos_rightFoot.z/500);
    gl.glScalef(1.0f, 1.0f, 1.0f);
    mayaCube.disableMaterial();
    mayaCube.draw();
  popMatrix();
  
  // rotate shoulder joints accordingly
  float[] m = new float[3];
  m = JointUtils.calcJointRotation(jointPos_rightElbow, jointPos_rightHand);
  gl.glMultMatrixf(m,0);
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
  //fill(60, 70, 150); 

  // draw the circle at the position of the head with the head size scaled by the distance scalar
  //sphere(jointPos_Proj.x, jointPos_Proj.y, distanceScalar*headsize, distanceScalar*headsize);
  pushMatrix();
    translate(jointPos_Proj.x/20, jointPos_Proj.y/20, distanceScalar);
    scale(3.5);
    mayaCube.draw();
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

///////////////////////////////////
//      Getters and setters      //
///////////////////////////////////

public PVector getVelocity()
{
  return avgVelocity;
}

///////////////////////////////////
//      Event-based Methods      //
///////////////////////////////////

// when a person ('user') enters the field of view
public void onNewUser(int userId)
{
  println("New User Detected - userId: " + userId);

  // start pose detection
  kinect.startPoseDetection("Psi", userId);
}

// when a person ('user') leaves the field of view 
public void onLostUser(int userId)
{
  println("User Lost - userId: " + userId);
}

// when a user begins a pose
public void onStartPose(String pose, int userId)
{
  println("Start of Pose Detected  - userId: " + userId + ", pose: " + pose);

  // stop pose detection
  kinect.stopPoseDetection(userId); 

  // start attempting to calibrate the skeleton
  kinect.requestCalibrationSkeleton(userId, true);
}

// when calibration begins
public void onStartCalibration(int userId)
{
  println("Beginning Calibration - userId: " + userId);
}

// when calibaration ends - successfully or unsucessfully 
public void onEndCalibration(int userId, boolean successfull)
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

public void onStartSession(PVector pos)
{
  println("onStartSession: " + pos);
  kinect.removeGesture("Click,Wave");
}

public void onEndSession()
{
  println("onEndSession: ");
  kinect.addGesture("Click,Wave");
}

public void onFocusSession(String strFocus, PVector pos, float progress)
{
  println("onFocusSession: focus=" + strFocus + ",pos=" + pos + ",progress=" + progress);
}

/////////////////////////////
//    Hand-based events    //
/////////////////////////////

public void onCreateHands(int handId, PVector pos, float time)
{
   // subtract old position from current position and assign that as the velocity
   // find the length of the vector
   // if > threshold, then pass that velocity to ball 
    handPosition = new PVector();
    handPositions = new ArrayList<PVector>();
    avgVelocity = new PVector();
  
    isTrackingHands = true;
    handPosition = pos;
    handPositions.add(0, handPosition);
    println("onCreateHands - handId: " + handId + ", pos: " + handPosition + ", in list: " + handPositions + ", time:" + time);
}


/************************************
*  Hand tracking properties
*      -time -> velocity, speed
*************************************/

float now,
      then,
      elapsedTime;

public void onUpdateHands(int handId, PVector pos, float time)
{
  then=now;
  now=time;
  elapsedTime=now-then;
  
  handPosition = pos;
  handPosition.x /= COORDINATE_SCALING;
  handPosition.y /= COORDINATE_SCALING;
  handPosition.z /= COORDINATE_SCALING;
  
  previousPos = new PVector();
  currentPos = new PVector();
  
  handPositions.add(0, handPosition);
  float[] vel = new float[3];
  float[] handPos = new float[3];
  float[] gravity = new float[3];
  speed = 0.0f;
  
      previousPos = handPositions.get(1);
      //println(previousPos);
      currentPos = handPositions.get(0);
      //println(currentPos);
      
      avgVelocity.x = ((currentPos.x - previousPos.x)/elapsedTime);
      avgVelocity.y = ((currentPos.y - previousPos.y)/elapsedTime);
      avgVelocity.z = ((currentPos.z - previousPos.z)/elapsedTime);     
      
      vel[0] = avgVelocity.x;
      vel[1] = avgVelocity.y;
      vel[2] = avgVelocity.z;
      
      speed = (float) (Math.sqrt(vel[0]*vel[0] + vel[1]*vel[1] + vel[2]*vel[2]));
      //speed /= COORDINATE_SCALING;        // scale the speed values to fit euler moveable object params
      
      myBall.setVelocity(vel);
      println("Magnitude (hand speed): " + " " + speed);
      
      for(int i = 0; i < gravity.length; i++)
        gravity[i] = -0.5;
        
      handPos[0] = currentPos.x;
      handPos[1] = currentPos.y;
      handPos[2] = currentPos.z;
              
//      pushMatrix();
//      pushStyle();
//         stroke(255, 255, 255);
//         fill(80, 140, 100);
//      translate (handPos[0], handPos[1], handPos[2]-ico1Size);
      
//      gl.glScalef(.04f, 0.04f, 0.05f);
//      ico1.create();
//
//      popStyle();
//      popMatrix();
      
      //myBall.setAcceleration(gravity);
      //println("setting velocity*************************************************"+vel[0]+" "+vel[1]+" "+vel[2]);
      
   if(handPositions.size() >= NUM_POSITIONS)
      handPositions.remove(handPositions.size()); // remove the first position before handPositions gets too large

//  println("onUpdateHands - handId: " + handId + ", pos: " + handPosition + ", in list: " + handPositions + ", time: " + time + "\n" +
//          "Velocity vector: " + avgVelocity.x + ", " + avgVelocity.y + ", " + avgVelocity.z);
}

public void onDestroyHands(int handId, float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
  handPositions.clear();      // no longer need array list of hand positions since we are no longer tracking them
  isTrackingHands = false;    // no longer tracking hands
}

////////////////////////////////
//    Gesture-based events    //
////////////////////////////////

public void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + 
    ", idPosition: " + idPosition + ", endPosition:" + endPosition);
}

public void onProgressGesture(String strGesture, PVector position, float progress)
{
  println("onProgressGesture - strGesture: " + strGesture + 
    ", position: " + position + ", progress:" + progress);
}
