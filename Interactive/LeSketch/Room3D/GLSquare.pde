///////////////////////////////////////////////////////////////////
// App:             GLSquare                                     //
// Author:          Michael Branton                              //
// Purpose:         Display a square                             //
//		The square is centered at the origin and 	 //
//		lies in the x-y plane. The length of a side      //
//		is specified in the constructor.		 //
//                                                               //
// Date:            Sept 30, 2011                                //
//                                                               //																 //
///////////////////////////////////////////////////////////////////

public class GLSquare extends GLGeometry
{
	float size;		// side length
	
	public GLSquare(float size)
	{
		super();
		this.size=size;
		this.setVertices();
	}
	
	public void setVertices()
	{
		this.vertices=new float[4*4];
		this.vertices[0]=-0.5f*this.size;
		this.vertices[1]=-0.5f*this.size;
		this.vertices[2]= 0.0f*this.size;
		this.vertices[3]= 1.0f;
		
		this.vertices[4]= 0.5f*this.size;
		this.vertices[5]=-0.5f*this.size;
		this.vertices[6]= 0.0f*this.size;
		this.vertices[7]= 1.0f;
		
		this.vertices[8]= 0.5f*this.size;
		this.vertices[9]= 0.5f*this.size;
		this.vertices[10]= 0.0f*this.size;
		this.vertices[11]= 1.0f;
		
		this.vertices[12]=-0.5f*this.size;
		this.vertices[13]= 0.5f*this.size;
		this.vertices[14]= 0.0f*this.size;
		this.vertices[15]= 1.0f;
	}
}
