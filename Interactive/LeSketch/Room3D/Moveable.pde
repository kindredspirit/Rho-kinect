
// ////////////////////////////////////////////////////////////////
// Class:           Moveable                                     //
// Author:          Michael Branton                              //
// Purpose:         represents a GLDrawable object which can     //
//                  be animated in some fashion, and has a       //
//                  position, velocity and acceleration. motion  //
//                  ostensibly may be in any number of dimnesions//
//                  though we default to 3. actual motion is     //
//                  determined by implementing the move method   //
//                                                               //
// Date:            March 19, 2002                               //
//                                                               //
///////////////////////////////////////////////////////////////////

public abstract class Moveable extends GLGeometry
{
	// object position, velocity, and acceleration
	public float[] position;
	protected float[] velocity;
	protected float[] acceleration;

	// and objects may have mass
	protected float mass;
	protected int dimension;

	public Moveable()
	{
                super();
		this.init();
	}

	public void init()
	{
		this.dimension = 3; // 3D is default
		this.position = new float[this.dimension];
		this.velocity = new float[this.dimension];
		this.acceleration = new float[this.dimension];

		// default value is for no motion
		for (int i = 0; i < this.dimension; i++)
		{
			this.position[i] = 0.0f;
			this.velocity[i] = 0.0f;
			this.acceleration[0] = 0.0f;
		}

		// default is unit mass
		this.setMass(0.1f);
	}

	public void setDimension(int dimension)
	{
		this.dimension = dimension;
	}

	public void setPosition(float x, float y, float z)
	{
		this.position[0] = x;
		this.position[1] = y;
		this.position[2] = z;
	}

	public void setPosition(float[] position)
	{
		this.position = position;
	}

	public void setVelocity(float vx, float vy, float vz)
	{
		this.velocity[0] = vx;
		this.velocity[1] = vy;
		this.velocity[2] = vz;
	}

	public void setVelocity(float[] velocity)
	{
		this.velocity = velocity;
                //System.out.println("velocity set********************************"+this.velocity[0]+" "+this.velocity[1]+" "+this.velocity[2]);
	}

	public void setAcceleration(float ax, float ay, float az)
	{
		this.acceleration[0] = ax;
		this.acceleration[1] = ay;
		this.acceleration[2] = az;
	}

	public void setAcceleration(float[] acceleration)
	{
		this.acceleration = acceleration;
	}

	public void setMass(float mass)
	{
		this.mass = mass;
	}

	public float getMass()
	{
		return this.mass;
	}

	public float[] getPosition()
	{
		float[] position = new float[this.dimension];
		for (int i = 0; i < this.dimension; i++)
		{
			position[i] = this.position[i];
		}
		return position;
	}

	public float[] getVelocity()
	{
		float[] velocity = new float[this.dimension];
		for (int i = 0; i < this.dimension; i++)
		{
			velocity[i] = this.velocity[i];
		}
		return velocity;
	}

	public float[] getAcceleration()
	{
		float[] acceleration = new float[this.dimension];
		for (int i = 0; i < this.dimension; i++)
		{
			acceleration[i] = this.acceleration[i];
		}
		return acceleration;
	}

	public int getDimension()
	{
		return this.dimension;
	}

	public void println()
	{
		for (int i = 0; i < this.dimension - 1; i++)
		{
			System.out.print("(" + this.position[i] + ",");
		}
		System.out.println(this.position[this.dimension - 1] + ")");

		for (int i = 0; i < this.dimension - 1; i++)
		{
			System.out.print("(" + this.velocity[i] + ",");
		}
		System.out.println(this.velocity[this.dimension - 1] + ")");

		for (int i = 0; i < this.dimension - 1; i++)
		{
			System.out.print("(" + this.acceleration[i] + ",");
		}
		System.out.println(this.acceleration[this.dimension - 1] + ")");
	}

        public void display()
        {
          super.display();
        }
        
	// must be implemented
	public abstract void move();
}
