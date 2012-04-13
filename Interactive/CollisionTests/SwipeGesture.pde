/**
* Class: SwipeGesture
*    extends XnVSwipeDetector
*
*  NITE API 1.5.1 - http://kinectcar.ronsper.com/docs/nite/XnVSwipeDetector_8h_source.html
*  SimpleOpenNI 0.26 - http://simple-openni.googlecode.com/svn/trunk/SimpleOpenNI/dist/all/SimpleOpenNI/documentation/index.html?SimpleOpenNI/XnVSwipeDetector.html
*
*  @since 10 March, 2012
**/
class SwipeGesture extends XnVSwipeDetector {
  
  SwipeGesture() {    
    RegisterSwipeRight(this);
    RegisterSwipeLeft(this);
    RegisterSwipeUp(this);
    RegisterSwipeDown(this);
  }
  
  void onSwipe(float vel, float angle) {
    println("SWIPE v:"+vel+" a:"+angle); 
  }
  void onSwipeUp(float vel, float angle) {
    println("SWIPE UP v:"+vel+" a:"+angle);
  }
    void onSwipeDown(float vel, float angle) {
    println("SWIPE DOWN v:"+vel+" a:"+angle);
  }
    void onSwipeLeft(float vel, float angle) {
    println("SWIPE LEFT v:"+vel+" a:"+angle);
  }
    void onSwipeRight(float vel, float angle) {
    println("SWIPE RIGHT v:"+vel+" a:"+angle);
  }
}

