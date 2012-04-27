/**
 * @author mbranton
 *
 * created: 26 July, 2011
 * 
 * purpose: base class for implementing "GL" aspects of geometry
 * 
 * Revised: 31 July, 2011
 * 			Added material properites for color
 * 			Added display method to account for additional attributes
 * 
 * Revised: 12 Aug, 2011
 * 			Added texture coordinates
 * 			Changed display to accept a ShaderControl object, rather
 * 			than just the attribute ids. Attribute ids are now handled 
 * 			locally within the display method.
 * 
 */


import java.awt.Color;
import javax.media.opengl.*;

public abstract class GLGeometry extends Geometry 
{
  /////////////////////////////////////////////
  //                  properties             //
  /////////////////////////////////////////////

  //	drawing mode; default to triangle_fan.
  //	some other possibilities are GL.GL_LINES
  //	or GL.GL_POINTS, etc
  int	mode;

  // color of the object
  float[] my_color;
  float[] colors;
  boolean stroked;
  
  // material properties
  float[] ambient;

  float[] diffuse;

  float[] specular;

  float shininess;

  // texture coordinates
  float[] texcoordinates;

  ////////////////////////////////////////////
  //              methods                   //
  ////////////////////////////////////////////

  public GLGeometry()
  {
    // default display mode
    this.setMode(GL.GL_POINTS);

    // default color
    this.my_color=new float[4];
    this.setColor(Color.white);

    this.vertices=null;
    this.normals=null;
    this.colors=null;
    this.stroked=false;
    this.texcoordinates=null;
  }


  public void setMode(int mode)
  {
    this.mode=mode;
  }

  public int getMode()
  {
    return this.mode;
  }

  private float[] getColorComponants(Color c)
  {
    float[] cf= {
      c.getRed()/(255.0f), c.getGreen()/(255.0f), c.getBlue()/(255.0f), c.getTransparency()
    };
    return cf;
  }

  public void setColor(Color aColor)
  {
    this.my_color=this.getColorComponants(aColor);
  }

  public void setColor(float red, float green, float blue)
  {
    this.my_color[0]=red;
    this.my_color[1]=green;
    this.my_color[2]=blue;
    this.my_color[3]=1.0f;
  }

  public void setColor(float red, float green, float blue, float a)
  {
    this.my_color[0]=red;
    this.my_color[1]=green;
    this.my_color[2]=blue;
    this.my_color[3]=a;
  }

  public void setColors(float[] colors)
  {
    this.colors=colors;
  }

  public float[] getColor()
  {
    return this.my_color;
  }

  public float[] getColors()
  {
    return this.colors;
  }
  
  public void setStroked(boolean stroked)
  {
    this.stroked=stroked;
  }

  public void setAmbient(Color aColor)
  {
    this.ambient=this.getColorComponants(aColor);
  }

  public void setAmbient(float red, float green, float blue, float a)
  {
    this.ambient[0]=red;
    this.ambient[1]=green;
    this.ambient[2]=blue;
    this.ambient[3]=a;
  }

  public float[] getAmbient()
  {
    return this.ambient;
  }

  public void setDiffuse(Color dColor)
  {
    this.diffuse=this.getColorComponants(dColor);
  }

  public void setDiffuse(float red, float green, float blue, float a)
  {
    this.diffuse[0]=red;
    this.diffuse[1]=green;
    this.diffuse[2]=blue;
    this.diffuse[3]=a;
  }

  public float[] getDiffuse()
  {
    return this.diffuse;
  }

  public void setSpecular(Color sColor)
  {
    this.specular=this.getColorComponants(sColor);
  }

  public void setSpecular(float red, float green, float blue, float a)
  {
    this.specular[0]=red;
    this.specular[1]=green;
    this.specular[2]=blue;
    this.specular[3]=a;
  }

  public float[] getSpecular()
  {
    return this.specular;
  }

  public void setShininess(float s)
  {
    this.shininess=s;
  }

  public float getShininess()
  {
    return this.shininess;
  }
  
  public void display()
  {
      if(this.stroked)
      {
        stroke(255*my_color[0],255*my_color[1],255*my_color[2]);
      }
      else
      {
          noStroke();
      }
      fill(255*my_color[0],255*my_color[1],255*my_color[2]);
      
      beginShape(this.mode);
        if(normals==null)
        {
              for(int i=0;i<vertices.length;i=i+4)
              {
                vertex(vertices[i],vertices[i+1],vertices[i+2]);
                //normal(normals[i],normals[i+1],normals[i+2]);
              }
        }
        else
        {
            int j=0;
            for(int i=0;i<vertices.length;i=i+4)
              {
                vertex(vertices[i],vertices[i+1],vertices[i+2]);
                normal(normals[j++],normals[j++],normals[j++]);
              }
        }
      endShape();
  }
}
