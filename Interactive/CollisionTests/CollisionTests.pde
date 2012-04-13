import processing.opengl.*;

import SimpleOpenNI.*;

/**
* Class: CollisionTests
*
* @author Moebot
**/

//////////////////////////////
//        properties        //
//////////////////////////////

SimpleOpenNI kinect;
GLGrid myGrid;
Navi myNavi;
float[] eye;

//Kinect stuff
boolean isTrackingHands = false;
PVector handVec = new PVector();
ArrayList handVecList = new ArrayList();
int handVecSize = 30;
String lastGesture = "";

//Session stuff
PushGesture pg;
XnVSessionManager sm;

ArrayList<OBJModel> myObjects;
OBJModel myBuilding;
OBJModel myMarker;

public void setup()
{
  size(800, 600, OPENGL);
  
  perspective(45, float(width)/float(height), 1, 500);
  smooth();
  background(0);
  
  //fun with cameras!
  eye = new float[3];
  eye[0] = 3;
  eye[1] = -5;
  eye[2] = 0;
 
  myNavi = new Navi();
  myNavi.setCamera(eye, 90, 180);
  
  myGrid = new GLGrid(-40, 40, -40, 40, 1, new Color(60, 80, 150));
  myGrid.setStroked(true);
  
  myBuilding = new OBJModel(this, "./data/buildingOne.obj", "aboslute", QUADS);
  myMarker = new OBJModel(this, "./data/cube.obj", "relative", QUADS);
  
  // Kinect stuff
  
  kinect = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  kinect.enableDepth();
  kinect.enableHands();
  kinect.enableGesture();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  //Gesture stuff
 
  kinect.addGesture("RaiseHand");
  kinect.addGesture("Click");
  kinect.addGesture("Wave");
  
  sm = kinect.createSessionManager("Click,Wave","RaiseHand");
  pg = new PushGesture();
  
  sm.addListener(pg);
  
}

public void draw()
{
  //need to clear the background to prevent things like gridception =P
  background(0,0,0);
  
  lights();
  myGrid.display();
  pushMatrix();
    translate(0,0,0);
    myBuilding.draw();
  popMatrix();
  
//  camera(myNavi.eye[0], myNavi.eye[1], myNavi.eye[2],
//        myNavi.look[0], myNavi.look[1], myNavi.look[2],
//        myNavi.up[0], myNavi.up[1], myNavi.up[2]);
        
  camera(myNavi.eye[0], myNavi.eye[1], myNavi.eye[2],
        handVec.x, handVec.y, handVec.z,
        myNavi.up[0], myNavi.up[1], myNavi.up[2]);
        
  GL gl = ((PGraphicsOpenGL) g).gl;
  
  
  kinect.update();
  if(isTrackingHands)
  {
    pushMatrix();
      translate(handVec.x, handVec.y, handVec.z);
//      rotateX(handVec.y*PI/3);
//      rotateY(handVec.x*PI/3);
      myMarker.draw();
    popMatrix();
  }
}

public void keyPressed(KeyEvent e)
{
  if(KeyEvent.getKeyText(e.getKeyCode()).equals("Up"))
    myNavi.lookUp();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Down"))
    myNavi.lookDown();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Right"))
    myNavi.lookRight();
  else if (KeyEvent.getKeyText(e.getKeyCode()).equals("Left"))
    myNavi.lookLeft();
  else if (e.getKeyChar() == 'w')
    myNavi.moveForward();
  else if (e.getKeyChar() == 'a')
    myNavi.lookLeft();
  else if (e.getKeyChar() == 's')
    myNavi.moveBackward();
  else if (e.getKeyChar() == 'd')
    myNavi.lookRight();
}

public void keyTyped(KeyEvent e)
{
  if (e.getKeyChar() == '-')
    myNavi.moveUp();
  else if (e.getKeyChar() == '+')
    myNavi.moveDown();
}

///////////////////////////////
//    getters and setters    //
///////////////////////////////

public float getHandX()
{
  return handVec.x;
}

public float getHandY()
{
  return handVec.y;
}

public float getHandZ()
{
  return handVec.z;
}  



// Simple OpenNI and Gesture events

// -----------------------------------------------------------------
// hand events

void onCreateHands(int handId,PVector pos,float time)
{
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);
 
  isTrackingHands = true;
  handVec = pos;
  
  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId,PVector pos,float time)
{
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handVec = pos;
  
  handVecList.add(0,pos);
  if(handVecList.size() >= handVecSize)
  { // remove the last point 
    handVecList.remove(handVecList.size()-1); 
  }
}

void onDestroyHands(int handId,float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
  
  isTrackingHands = false;
  kinect.addGesture(lastGesture);
}

// -----------------------------------------------------------------
// gesture events

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);
  
  lastGesture = strGesture;
  kinect.removeGesture(strGesture); 
  kinect.startTrackingHands(endPosition);
  
}

void onProgressGesture(String strGesture, PVector position,float progress)
{
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
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
