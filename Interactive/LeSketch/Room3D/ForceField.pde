// ////////////////////////////////////////////////////////////////
// Interface:       ForceField                                   //
// Author:          Michael Branton                              //
// Purpose:         To be implemented by any class which wishes  //
//                  to represent an external force, represented  //
//                  as a (mathematical) vector                   //
//                                                               //
// Date:            March 19, 2002                               //
//                                                               //
///////////////////////////////////////////////////////////////////

public interface ForceField
{
	public float[] getForce(float x, float y, float z, float t);
}
