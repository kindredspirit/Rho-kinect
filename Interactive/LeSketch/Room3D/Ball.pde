///////////////////////////////////////////////////////////////////
// Class:           Ball                                         //
// Author:          Michael Branton                              //
// Purpose:         a moving  ball, implemented using a          //
//                  particle system. motion is due to            //
//                  gravity alone.                               //
//                                                               //
// Date:            May 24, 1999                                 //
// Modified:        October 25,1999                              //
//                  Added interaction with a force field; made   //
//                  class abstract.                              //
//                                                               //
//                  March 19, 2002                               //
//                  Factored class into a Hierarchy:             //
//                  GLDrawableObject<-Moveable<-Ball             //
//                  and made ForceField an Interface             //
//                                                               //
// Revised: 		Oct  31, 2004 to use JOGL		 //
//			Sept 30, 2011 to use JOGL 2		 //
///////////////////////////////////////////////////////////////////

import java.awt.Color;
import javax.media.opengl.*;
public class Ball extends RKMoveable
{
  // ///////////////////////////////////////////
  // properties //
  // ///////////////////////////////////////////

  // the radius
  private float radius;

  // only force acting here is gravity
  protected float[] gravity;

  // resolution at which ball is drawn
  private int resolution;

  // default resolution
  private static final int DEF_RES = 100;
  GLSphere myGeometry;
  
  //GL component
  GL gl = ((PGraphicsOpenGL) g).gl;     //reference GL object
  
  // //////////////////////////////////////////
  // methods //
  // //////////////////////////////////////////

  public Ball(float radius)
  {
    super();
    this.init(radius);
  }

  public void init(float radius)
  {
    this.resolution = DEF_RES;
    this.setRadius(radius);
    this.setVertices();
    this.gravity = new float[this.getDimension()];
    for (int i = 0; i < this.getDimension(); i++)
    {
      this.gravity[i] = 0.0f;
    }
  }

  public void setVertices()
  {
    myGeometry = new GLSphere(this.resolution, this.resolution);
    this.vertices = new float[myGeometry.vertices.length];
    for (int i = 0; i < myGeometry.vertices.length; i++)
    {
      if ((i + 1) % 4 != 0)
      {
        this.vertices[i] = myGeometry.vertices[i] * this.radius;
      } 
      else
      {
        this.vertices[i] = 1.0f;
      }
     
      myGeometry.setAmbient(Color.white);
      myGeometry.setDiffuse(Color.white);
      myGeometry.setSpecular(Color.white);
      myGeometry.setShininess(1f);
      myGeometry.setMode(GL.GL_TRIANGLES);
    }
  }

  public void setResolution(int resolution)
  {
    this.resolution = resolution;
    this.setVertices();
  }

  public int getResolution()
  {
    return this.resolution;
  }

  public float getRadius()
  {
    return radius;
  }

  public void setRadius(float radius)
  {
    this.radius = radius;
  }

  public void setForce(float g)
  {
    this.gravity[1] = g;
  }

  public float[] getForce(float x, float y, float z, float t)
  {
    return this.gravity;
  }

  public void setForce(float[] g)
  {
    this.gravity = g;
  }

  public void display()
  {
//    gl.glUniformMatrix4fv(shader.uniform.get("Model").intValue(), 1, true, 
//    MatrixFactory.translation(this.position[0], this.position[1], 
//    this.position[2]), 0);
    
    gl.glTranslatef(position[0], position[1], position[2]);
   // myGeometry.display();
   sphere(0.7f);
  }

  public void stop()
  {
    for (int i = 0; i < this.getDimension(); i++)
    {
      this.gravity[i] = 0.0f;
    }
    this.setForce(0);
    this.setAcceleration(0, 0, 0);
    this.setVelocity(0, 0, 0);
  }

  public float[] getAmbient()
  {
    return myGeometry.getAmbient();
  }

  public float[] getPosition()
  {
    return this.position;
  }

  public float[] getDiffuse()
  {
    return myGeometry.getDiffuse();
  }

  public float[] getSpecular()
  {
    return myGeometry.getSpecular();
  }

  public float getShininess()
  {
    return myGeometry.getShininess();
  }
}
