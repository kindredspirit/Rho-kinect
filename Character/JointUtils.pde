/**
* Class JointUtils - a class to do all the calculations needed
*            for distance between joints, joint rotations, etc.
*  @author Moe
*  @since 31 March, 2012
*      revision 1: moved methods which were in the main class
*           into its own class to keep better track of them.
*/

public static class JointUtils
{
  
  // computes the axis of rotation given two joint vectors
  // input: the joint vectors
  // returns: a float array that represents the axis about which to rotate
//  public float[] findAxisOfRot(PVector joint0, PVector joint1)
//  {
//    float[] n = MatrixFactory.crossprod(joint0,joint1) / 
//    return n;
//  }
  
  
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
}
