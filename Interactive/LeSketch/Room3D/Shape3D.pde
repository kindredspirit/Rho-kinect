/**
*  Abstract Class: Shape3D - Defining the three axes on which a 3D object can be drawn.
*                            Giving each vertex of the 3D object an associated x, y, and z coordinate.
*                            Making each vertex into a point using PVector.
*  @version: 1.0 - base
**/

public abstract class Shape3D{
  float x, y, z;
  float w, h, d;

  public Shape3D(){
  }

  public Shape3D(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Shape3D(PVector p){
    x = p.x;
    y = p.y;
    z = p.z;
  }


  public Shape3D(Dimension3D dim){
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  public Shape3D(float x, float y, float z, float w, float h, float d){
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.d = d;
  }

  public Shape3D(float x, float y, float z, Dimension3D dim){
    this.x = x;
    this.y = y;
    this.z = z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  public Shape3D(PVector p, Dimension3D dim){
    x = p.x;
    y = p.y;
    z = p.z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  public void setLoc(PVector p){
    x=p.x;
    y=p.y;
    z=p.z;
  }

  public void setLoc(float x, float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }


  // override if you need these
  public void rotX(float theta){
  }

  public void rotY(float theta){
  }

  public void rotZ(float theta){
  }

  // must be implemented in subclasses
  public abstract void init();
  public abstract void create();
}

