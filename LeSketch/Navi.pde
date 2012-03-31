/**
*  Class Navi - does all the math for camera controls
*               and view changes as the player is moving
*               around in the 3D scene.
*  @author Moe
*  @since September 2011  
*      -revision 2: ported from JOGL to processing environment
*/

public class Navi
{
  public float[] eye, look, lookv, up;
  private double phi, theta;
  private double angle_incr = 10;	// increment viewing angles by 10 degrees
  private float distance;

  public Navi()
  {
    this.eye=new float[3];
    this.eye[0] = 0.0f;
    this.eye[1] = 0.0f;
    this.eye[2] = 0.0f;

    this.distance = 1.0f;
    this.angle_incr=Math.PI/18;
    this.phi = Math.PI/2;
    this.theta = Math.PI;

    this.init();
  }
  
  private void init()
  {
    float phi_s =   (float)Math.sin(this.phi);
    float phi_c =   (float)Math.cos(this.phi);
    float theta_c = (float)Math.cos(this.theta);
    float theta_s = (float)Math.sin(this.theta);

    this.lookv = new float[3];
    this.lookv[0] = phi_s * theta_s;
    this.lookv[1] = phi_c;
    this.lookv[2] = phi_s * theta_c;

    this.look = new float[3];
    this.look[0] = this.eye[0] + this.lookv[0];
    this.look[1] = this.eye[1] + this.lookv[1];
    this.look[2] = this.eye[2] + this.lookv[2];

    this.up = new float[3];
    this.up[0] = -theta_s * phi_c;
    this.up[1] = phi_s;
    this.up[2] = -theta_c * phi_c;
  }

  public void lookDown()
  {
    this.phi -=  angle_incr;
    float phi_s   = (float)Math.sin(this.phi);
    float phi_c   = (float)Math.cos(this.phi);
    float theta_c = (float)Math.cos(this.theta);
    float theta_s = (float)Math.sin(this.theta);
    this.lookv[0] = phi_s*theta_s;
    this.lookv[1] = phi_c;
    this.lookv[2] = phi_s*theta_c;
    this.look[0]  = this.eye[0] + this.lookv[0];
    this.look[1]  = this.eye[1] + this.lookv[1];
    this.look[2]  = this.eye[2] + this.lookv[2];
    this.up[0]    = -theta_s*phi_c;
    this.up[1]    = phi_s;
    this.up[2]    = -theta_c*phi_c;
  }

  public void lookLeft()
  {
    this.theta += angle_incr;
    if (this.theta > 6.2831853071795862d)  // 2Pi
      this.theta = 0.0D;
    float phi_s   = (float)Math.sin(this.phi);
    float phi_c   = (float)Math.cos(this.phi);
    float theta_c = (float)Math.cos(this.theta);
    float theta_s = (float)Math.sin(this.theta);
    this.lookv[0] = phi_s*theta_s;
    this.lookv[2] = phi_s*theta_c;
    this.look[0]  = this.eye[0] + this.lookv[0];
    this.look[2]  = this.eye[2] + this.lookv[2];
    this.up[0]    = -theta_s*phi_c;
    this.up[2]    = -theta_c*phi_c;
  }

  public void lookRight()
  {
    this.theta -= angle_incr;
    if (this.theta < 0.0D)
      this.theta = 6.2831853071795862d;  // 2Pi
    float phi_s   = (float)Math.sin(this.phi);
    float phi_c   = (float)Math.cos(this.phi);
    float theta_c = (float)Math.cos(this.theta);
    float theta_s = (float)Math.sin(this.theta);

    this.lookv[0] = phi_s*theta_s;
    this.lookv[2] = phi_s*theta_c;
    this.look[0]  = this.eye[0] + this.lookv[0];
    this.look[2]  = this.eye[2] + this.lookv[2];
    this.up[0]    = -theta_s*phi_c;
    this.up[2]    = -theta_c*phi_c;
  }

  public void lookUp()
  {
    this.phi += angle_incr;
    float phi_s   = (float)Math.sin(this.phi);
    float phi_c   = (float)Math.cos(this.phi);
    float theta_c = (float)Math.cos(this.theta);
    float theta_s = (float)Math.sin(this.theta);

    this.lookv[0] = phi_s*theta_s;
    this.lookv[1] = phi_c;
    this.lookv[2] = phi_s*theta_c;
    this.look[0] = this.eye[0] + this.lookv[0];
    this.look[1] = this.eye[1] + this.lookv[1];
    this.look[2] = this.eye[2] + this.lookv[2];
    this.up[0]   = -theta_s*phi_c;
    this.up[1]   = phi_s;
    this.up[2]   = -theta_c*phi_c;
  }



  public void moveBackward()
  {
    this.eye[0] -= this.distance * this.lookv[0];
    this.eye[1] -= this.distance * this.lookv[1];
    this.eye[2] -= this.distance * this.lookv[2];
    this.look[0] = this.eye[0] + this.lookv[0];
    this.look[1] = this.eye[1] + this.lookv[1];
    this.look[2] = this.eye[2] + this.lookv[2];
  }

  public void moveDown()
  {
    this.eye[1] -= this.distance;
    this.look[1] = this.eye[1] + this.lookv[1];
  }

  public void moveForward()
  {
    this.eye[0] += this.distance * this.lookv[0];
    this.eye[1] += this.distance * this.lookv[1];
    this.eye[2] += this.distance * this.lookv[2];
    this.look[0] = this.eye[0] + this.lookv[0];
    this.look[1] = this.eye[1] + this.lookv[1];
    this.look[2] = this.eye[2] + this.lookv[2];
  }

  public void moveUp()
  {
    this.eye[1] += this.distance;
    this.look[1] = this.eye[1] + this.lookv[1];
  }

  public void setDistance(float distance)
  {
    this.distance = distance;
    this.init();
  }

  public float getDistance()
  {
    return distance;
  }

  public void setAngleIncr(double ai)
  {
    this.angle_incr=ai;
  }

  public double getAngleIncr()
  {
    return this.angle_incr;
  }

  public float[] getEye()
  {
    return this.eye;
  }

  public float[] getLook()

  {
    return this.look;
  }
  
  public float[] getLookv()

  {
    return this.lookv;
  }

  public float[] getUp()

  {
    return this.up;
  }

  public void setCamera(float[] eye, double phi, double theta)
  {
    this.eye=eye;
    this.phi=Math.toRadians(phi);
    this.theta=Math.toRadians(theta);
    this.init();
  }

  public double getPhi()
  {
    return this.phi;
  }
}

