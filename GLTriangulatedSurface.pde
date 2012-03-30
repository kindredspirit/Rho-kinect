///////////////////////////////////////////////////////////////////
// Class:           GLTriangulatedSurface                        //
// Author:          Michael Branton                              //
// Purpose:         Stores the vertices of a mesh as triangles   //
//                                                               //
//                                                               //
// Date:            Sept 30, 2000                                //
// Revised:			Aug 3, 2011  for use with JOGL 2 //
//                                                               //
// ////////////////////////////////////////////////////////////////

public abstract class GLTriangulatedSurface extends GLGeometry
{    
	protected int size;
    protected int udiv,         	// # of divisions in each direction
                  vdiv;         	// of the mesh
    protected int vlocation,
    		  nlocation;
    
    public GLTriangulatedSurface()
    {
    	this.udiv=0;
        this.vdiv=0;
        this.vlocation=0;
        this.nlocation=0;
        this.setVertices();
        this.setMode(TRIANGLES);
    }
    
    public GLTriangulatedSurface(int udiv, int vdiv)
    {
    	this.udiv=udiv;
        this.vdiv=vdiv;
        this.size=6*this.udiv*this.vdiv;
        this.vertices = new float[4*this.size];
        this.normals = new float[3*this.size];
        this.setVertices(udiv,vdiv);
        this.setMode(TRIANGLES);
    }
    
    protected void setVertices()
    {
    	this.vertices=null;
    	this.normals=null;
    }
    
    protected void setVertices(int udiv, int vdiv)
    {
    }
    
    // add the vertices of each triangle and the normal vector at each vertex
    protected void addTriangle(   float x1, float y1, float z1,
                                  float x2, float y2, float z2,
                                  float x3, float y3, float z3)
    {
        // vertex (x1,y1,z1)
        this.vertices[this.vlocation++]=x1;
        this.vertices[this.vlocation++]=y1;
        this.vertices[this.vlocation++]=z1;
        this.vertices[this.vlocation++]=1;
        
        // vertex (x2,y2,z2)
        this.vertices[this.vlocation++]=x2;
        this.vertices[this.vlocation++]=y2;
        this.vertices[this.vlocation++]=z2;
        this.vertices[this.vlocation++]=1;
        
        // vertex (x3,y3,z3)
        this.vertices[this.vlocation++]=x3;
        this.vertices[this.vlocation++]=y3;
        this.vertices[this.vlocation++]=z3;
        this.vertices[this.vlocation++]=1;
     }
    
    protected void addTriangleWithNormal(
    		float x1, float y1, float z1,
            float x2, float y2, float z2,
            float x3, float y3, float z3)
    {
    	// vertex (x1,y1,z1)
    	this.addTriangle(x1, y1, z1,x2, y2, z2,x3, y3, z3);
    	
    	float[] n=MatrixFactory.normalize(MatrixFactory.crossprod(x2-x1,y2-y1,z2-z1,x3-x1,y3-y1,z3-z1));
    	this.normals[this.nlocation++]=n[0];
    	this.normals[this.nlocation++]=n[1];
    	this.normals[this.nlocation++]=n[2];
    	
    	// vertex (x2,y2,z2)
    	this.normals[this.nlocation++]=n[0];
    	this.normals[this.nlocation++]=n[1];
    	this.normals[this.nlocation++]=n[2];


    	// vertex (x3,y3,z3)
    	this.normals[this.nlocation++]=n[0];
    	this.normals[this.nlocation++]=n[1];
    	this.normals[this.nlocation++]=n[2];
    }
    
    public int getUdiv()
    {
        return this.udiv;
    }
    
    public int getVdiv()
    {
        return this.vdiv;
    }
    
    public int getSize()
    {
        return this.size;
    }
}
