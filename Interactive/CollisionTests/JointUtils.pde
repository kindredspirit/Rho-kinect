/**
* Class JointUtils - a class to do all the calculations needed
*            for distance between joints, joint rotations, etc.
*  @author Moe
*  @since 31 March, 2012
*      revision 1: moved methods which were in the main class
*           into its own class to keep better track of them.
*      revision 2: rotation actually kinda works this time
*/

public static class JointUtils
{
  private static PVector n;
  private static float theta;
  public static float[] rotMatrix;
  
  public JointUtils()
  {
    rotMatrix = new float[3];
  }
  
  /* computes the axis of rotation given two joint vectors
   * input: the joint vectors
   *returns: n - a float array that represents the axis about which to rotate
   */
  public static PVector findAxisOfRot(PVector joint1, PVector joint2)
  {
    n = MatrixFactory.normalizeV(MatrixFactory.crossprod(joint1, joint2));
    println("This is my axis: ");
    println(n);
    return n;
  }
  
  public static float calcTheta(PVector v1, PVector v2)
  {
    PVector nV1 = MatrixFactory.normalizeV(v1);
    PVector nV2 = MatrixFactory.normalizeV(v2);
    float d = MatrixFactory.dot(nV1, nV2);
    theta = acos(d);
    
    return theta;
  }
  
  // calculate the distance between any two points in 3D space and return it as a float
  public static float distance3D(PVector point1, PVector point2)
  {
     float diff_x, diff_y, diff_z;    // to store differences along x, y and z axes
     float distance;                  // to store final distance value using 2 vectors
   
     // calculate the difference between the two points
     diff_x = point1.x - point2.x;
     diff_y = point1.y - point2.y;
     diff_z = point1.z - point2.z; 
   
     // calculate the Euclidean distance between the two points
     distance = sqrt(pow(diff_x,2)+pow(diff_y,2)+pow(diff_z,2));
   
     return distance;  // return the distance as a float
  }
  
  /*
  * calcJointLink() - calculates the distance between two
  *                  arbitrary joints, finds the resulting vector's
  *                  axis of rotation, then spits out a rotation matrix
  *
  */
  public static void calcJointRotation(PVector joint1, PVector joint2)
  {   
      //scale the limb to fit between the two joints
      
      float distance = distance3D(joint1, joint2);
      MatrixFactory.scale(distance);
      
      //rotate the geometry to the orientation of the connecting joint
      float theta = calcTheta(joint1, joint2);
      
      //get the n value for the axis
      findAxisOfRot(joint1, joint2);
      
      //load the values of the axis vector into a float[]
      float[] axis = new float[3];
      axis[0] = n.x;
      axis[1] = n.y;
      axis[2] = n.z;
  
      //perform rotations and send it to the gl object
      rotMatrix = MatrixFactory.rotation(theta, axis);
  }
  
  public float[] getRotMatrix()
  {
     return rotMatrix; 
  }
}
