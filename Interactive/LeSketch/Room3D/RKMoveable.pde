// ////////////////////////////////////////////////////////////////
// Class:           RKMoveable                                	 //
// Author:          Michael Branton                              //
// Purpose:         Uses the Runge=Kutta method of integration to//
//                  determine the motion of a GLDrawableObject   //
//                  acting under an external force, represented  //
//                  by the ForceField. Actual motion will be     //
//                  by implementing the ForceField's             //
//                  getForceField(x,y,z,t) method which should   //
//                  return an array containing the components    //
//                  of the force vector acting at the point      //
//                  with spatial coordinates (x,y,z) and time t  //
//                                                               //
// Date:            March 16, 2010                               //
//                                                               //
///////////////////////////////////////////////////////////////////

public abstract class RKMoveable extends Moveable implements ForceField
{
  // time step
  public float dt;

  // keep track of time
  protected float t = 0;

  public RKMoveable()
  {
    super();

    // init time step; no motion will occur w/ this
    // as no time will pass

    this.dt = 0.0f;
  }

  public void setTimeStep(float dt)
  {
    this.dt = dt;
  }

  public float getTimeStep()
  {
    return this.dt;
  }

  public void move()
  {
    System.out.println("************** YO! **************");
//    System.out.println("Ball position (initial): " + position[0] + " " + position[1] + " " + position[2]);
    // update position & velocity using runge-kutta (simpson's rule) method
    t = t + dt;
    for (int i = 0; i < this.dimension; i++)
    {
      // dv/dt=a+F/m
      // velocity at the "left"
      float vold = velocity[i];

      // velocity at the"middle"
      float vtemp = velocity[i]+ dt/ 2 * ((this.acceleration[i] + this.getForce(this.position[0], 
      this.position[1], this.position[2], t)[i]) / this.mass);

      // velocity at the "right"
      this.velocity[i] = this.velocity[i] + (this.acceleration[i] + (this.getForce(this.position[0], 
      this.position[1], this.position[2], t)[i])/ this.mass) * this.dt;
      // dp/dt=v
      this.position[i] = this.position[i] + this.dt / 6 * (vold + 4 * vtemp + this.velocity[i]);
//      System.out.println("RKMoveable velocity: " + velocity[0] + " " + velocity[1] + " " + velocity[2]);
//      System.out.println("Ball position (translated): " + position[0] + " " + position[1] + " " + position[2]); 
    }
  }
}
