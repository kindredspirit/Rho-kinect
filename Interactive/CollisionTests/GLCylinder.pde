// ////////////////////////////////////////////////////////////////
// Class:           GLCylinder                                   //
// Author:          Michael Branton                              //
// Purpose:         Represents a vertical cylinder, with base    //
//                  centered at the origin, radius and height 1  //
//                                                               //
//                                                               //
// Date:            Sept 30, 2000                                //
//                                                               //
// ////////////////////////////////////////////////////////////////

public class GLCylinder extends GLParametricSurface
{
    private static final double TWO_PI=2*Math.PI;
    //private static float length = JointUtils.distance3D();
    
    public GLCylinder(int udiv,int vdiv)
    {
        super(udiv,vdiv);
    }

    protected float x(int u,int v)
    {
        return (float)Math.cos(v*TWO_PI/this.vdiv);
    }    

    protected float y(int u, int v)
    {
        return (float) u/(float)this.udiv;
    }

    protected float z(int u,int v)
    {
        return (float)Math.sin(v*TWO_PI/this.vdiv);
    }
}
