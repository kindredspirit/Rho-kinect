public class GLGrid extends GLGeometry
{

    // properties
    float minx,maxx,minz,maxz,tic;
    
    // methods
    public GLGrid(float minx, float maxx, float minz, float maxz, float tic)

    {
        this.minx=minx;
        this.maxx=maxx;
        this.minz=minz;
        this.maxz=maxz;
        this.tic=tic;
        this.setColor(Color.white);
        this.setMode(LINES);
        this.setVertices();
    }

    public GLGrid(float minx, float maxx, float minz, float maxz, float tic,
                float red, float green, float blue)
    {
        this(minx,maxx,minz,maxz,tic);
        this.setColor(red,green,blue);
    }

    public GLGrid(float minx, float maxx, float minz, float maxz, float tic,
                Color aColor)
    {
        this(minx,maxx,minz,maxz,tic);
        this.setColor(aColor);
    }
    
    public void setVertices()
    {
    	float incr;

        int rows=Math.round((this.maxz-this.minz)/this.tic);
        int cols=Math.round((this.maxx-this.minx)/this.tic); ;
        this.vertices=new float[(rows+cols+2)*8];
        incr=0.0f;
        int i=0;
        for(int row=0;row<=rows;row++)
        {
        	this.vertices[i++]=this.minx;
        	this.vertices[i++]=0.0f;
        	this.vertices[i++]=this.minz+incr;
        	this.vertices[i++]=1.0f;
        	
        	this.vertices[i++]=this.maxx;
        	this.vertices[i++]=0.0f;
        	this.vertices[i++]=this.minz+incr;
        	this.vertices[i++]=1.0f;
        	incr+=this.tic;
        }
        
        incr=0.0f;
        for(int col=0;col<=cols;col++)
        {
        	this.vertices[i++]=this.minx+incr;
        	this.vertices[i++]=0.0f;
        	this.vertices[i++]=this.minz;
        	this.vertices[i++]=1.0f;
        	
        	this.vertices[i++]=this.minx+incr;
        	this.vertices[i++]=0.0f;
        	this.vertices[i++]=this.maxz;
        	this.vertices[i++]=1.0f;
        	incr+=this.tic;
        }
    }
}
