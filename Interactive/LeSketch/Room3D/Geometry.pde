public abstract class Geometry 
{
	// the vertices of the polygon
	protected float vertices[];
	
	// and the normals
	protected float normals[];
	
	protected void setVertices()
	{
		
	}
	
	protected void setVerticesAndNormals()
	{
		
	}
	
	public void printVertices()
	{
		for(int i=0;i<this.vertices.length;i=i+4)
		{
			System.out.println("("+this.vertices[i]+","+this.vertices[i+1]+","+this.vertices[i+2]+","+this.vertices[i+3]+")\n");
		}
	}
	
	public void printNormals()
	{
		for(int i=0;i<this.normals.length;i=i+3)
		{
			System.out.println("("+this.normals[i]+","+this.normals[i+1]+","+this.normals[i+2]+")\n");
		}
	}
	
	public void printVerticesAndNormals()
	{
		int vpos=0, npos=0;
		for(int i=0;i<this.vertices.length/4;i++)
		{
			System.out.println("v "+i+":("+this.vertices[vpos++]+","+this.vertices[vpos++]+","+this.vertices[vpos++]+","+this.vertices[vpos++]+")");
			System.out.println("n "+i+":("+this.normals[npos++]+","+this.normals[npos++]+","+this.normals[npos++]+")");
		}
	}
}
