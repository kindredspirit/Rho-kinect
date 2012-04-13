/**
* Class: PushGesture -
*    extends XnVPushDetector
*  Defines a push gesture as per OpenNI/NITE API v1.5.1
*  and implements necessary callback methods to this parent class:
*  
*  NITE API 1.5.1 - http://kinectcar.ronsper.com/docs/nite/XnVPushDetector_8h_source.html
*  SimpleOpenNI 0.26 - http://simple-openni.googlecode.com/svn/trunk/SimpleOpenNI/dist/all/SimpleOpenNI/documentation/SimpleOpenNI/XnVPushDetector.html
*
*  @since 10 March, 2012
**/
class PushGesture extends XnVPushDetector {

  PushGesture() {    
    RegisterPush(this);
    RegisterDeactivate(this);
    RegisterPrimaryPointCreate(this);
    // RegisterPointCreate(this);
    RegisterPointUpdate(this);
    RegisterPointDestroy(this);

    // RegisterStabilized(this);
  }

  void onPush(float vel, float angle) {
    println(">>>>>>>>> PUSH v:" + vel + "a: " + angle);
    //   println("ID = " +  GetPrimaryID()+" immduration: " + GetPushImmediateDuration()+" immoffset: "+GetPushImmediateOffset()  );
  }

  void onPointUpdate(XnVHandPointContext cxt) {
//    println("PUSH onPointUpdate " + cxt.getFTime() +":"+cxt.getNUserID()+"("+cxt.getNID()  +") "+ 
//    cxt.getPtPosition().getX() + " " +
//    cxt.getPtPosition().getY()+" " +
//    cxt.getPtPosition().getZ());

    //load updated push points into a queue or something and compare the current pos with the previous pos

    
  }

  void onPrimaryPointCreate(XnVHandPointContext pContext, XnPoint3D ptFocus)
  {
    //println(">>>>>>>>> PUSH onPrimaryPointCreate:");
  }

  void onPointDestroy(int nID)
  {
    //println(">>>>>>>>> PUSH onPointDestroy: " + nID);
  }
}

