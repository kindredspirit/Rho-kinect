// ////////////////////////////////////////////////////////////////
// Class:           GLSphere                                     //
// Author:          Michael Branton                              //
// Purpose:         Represents a unit sphere,                    //
//                  centered at the origin                       //
//                                                               //
//                                                               //
// Date:            Sept 30, 2000                                //
//                                                               //
// ////////////////////////////////////////////////////////////////

public class GLSphere extends GLParametricSurface
{
	private static final double TWO_PI = 2 * Math.PI;

	public GLSphere(int udiv, int vdiv)
	{
		super(udiv, vdiv);
	}

	protected float x(int u, int v)
	{
		return (float) Math.sin(u * Math.PI / this.udiv)
				* (float) Math.cos(v * TWO_PI / this.vdiv);
	}

	protected float y(int u, int v)
	{
		return (float) Math.sin(u * Math.PI / this.udiv)
				* (float) Math.sin(v * TWO_PI / this.vdiv);
	}

	protected float z(int u, int v)
	{
		return (float) Math.cos(u * Math.PI / this.udiv);
	}
}
