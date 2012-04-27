///////////////////////////////////////////////////////
//                                                   //
//  Class: GLElongatedCube                           //
//  Author: Moebot                                   //
//  Purpose: Parametrically creates a scaled 3D cube //
//           by defining equations for replication   //
//           of vertices along the x, y and z axis   //
//                                                   //
//                                                   //
//  Since: March 15 2012                             //
//                                                   //
///////////////////////////////////////////////////////

public class GLElongatedCube extends GLParametricSurface 
{
  //a = size of the cube
  int a = 2;
  int b = 4;
  
  public GLElongatedCube(int udiv, int vdiv)
  {
    super(udiv, vdiv);  
  }
  
  //vertices replicated along the x axis
  protected float x(int u, int v)
  {
    return (a*(sin(u))*cos(v)) / pow((pow(sin(vdiv), 6) + pow(cos(vdiv), 6) + pow(cos(udiv),6)), (1/6));
  }
  
  //vertices replicated along the y axis
  protected float y(int u, int v)
  {
    return (b*(sin(u))*sin(v)) / pow((pow(sin(vdiv), 6) + pow(cos(vdiv), 6) + pow(cos(udiv), 6)) , (1/6));
  }
  
  //vertices replicated along the z axis
  protected float z(int u, int v)
  {
    return (a*(cos(u))) / pow((pow(sin(vdiv),6) + pow(cos(vdiv), 6) + pow(cos(udiv), 6)), (1/6));
  }
}
