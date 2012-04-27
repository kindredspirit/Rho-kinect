/**
 * @author mbranton
 * Modified by: Moe
 * Created: on July 24, 2011
 *
 * Purpose: provides static methods for matrix and vector operations
 * 			matrices are stored in row-major order and are assumed 4x4,
 * 			while vectors are assumed to be 1x3.
 */

import java.util.Arrays;

static class MatrixFactory
{

  ////////////////////////////////////////////
  //              methods                   //
  ////////////////////////////////////////////

  // create a matrix for orthographic projection
  // input:   boundaries of the viewing frustrum
  // returns: 4x4 matrix required to do orthographic projection
  public static float[] ortho(float left, float right, float bottom, float top, float near, float far)
  {
    float[] m=identity();
    float rl=right-left;
    float tb=top-bottom;
    float fn=far-near;
    if ((rl!=0) && (tb!=0)&& fn!=0)
    {
      m[0]=2/(rl);
      m[3]=-(left+right)/rl;
      m[5]=2/tb;
      m[7]=-(top+bottom)/tb;
      m[10]=-2/fn;
      m[11]=-(far+near)/fn;
    }
    return m;
  }


  // creates a matrix for perspective projection
  // input: fovy The field of view in y-direction, in degrees
  //        aspect The aspect ratio
  //        zNear The near clipping plane
  //        zFar The far clipping plane
  //returns:4x4 matrix for doing perspective projection
  public static float[] perspective(float fovy, float aspect, float zNear, float zFar)
  {
    float fovyr = (float)Math.toRadians(fovy / 2);
    float deltaZ = zFar - zNear;
    float sine = (float)Math.sin(fovyr);

    // check to avoid division by 0
    if ((deltaZ == 0) || (sine == 0) || (aspect == 0)) 
    {
      return identity();
    }

    float cotangent = (float)Math.cos(fovyr) / sine;
    float m[]= identity();
    m[0*4+0] = cotangent / aspect;
    m[1*4+1] = cotangent;
    m[2*4+2] = -(zFar+zNear) / deltaZ;
    m[2*4+3] = -2*zNear * zFar / deltaZ;
    m[3*4+2] = -1;
    m[3*4+3] = 0;
    return m;
  }

  // creates a matrix corresponding to the camera's view
  // input: 	eye  The location of the camera
  //			look The direction the camera is looking in
  //			up   The orientation of the camera (which was is up)
  // returns: a 4x4 matrix corresponding to the camera's view
  public static float[] lookAt(float[] eye, float[] look, float[] up)
  {
    float[] m=identity();
    float[] n=normalize(sub(eye, look));
    float[] v=sub(up, scale(dot(up, n), n));
    float[] u=normalize(crossprod(v, n));
    m[0]=u[0];
    m[1]=u[1];
    m[2]=u[2];
    m[3]=-dot(eye, u);
    m[4]=v[0];
    m[5]=v[1];
    m[6]=v[2];
    m[7]=-dot(eye, v);
    m[8]=n[0];
    m[9]=n[1];
    m[10]=n[2];
    m[11]=-dot(eye, n);

    return m;
  }

  // creates an identity matrix
  // return: a 4x4 identity matrix
  public static float[] identity()
  {
    float m[] = new float[16];
    Arrays.fill(m, 0);
    m[0] = m[5] = m[10] = m[15] = 1.0f;
    return m;
  }

  // multiple 2 4x4 matrices together
  // input:   the 2 matrices
  // returns: the matrix product
  public static float[] multiply(float m0[], float m1[])
  {
    float m[] = new float[16];
    for (int x=0; x < 4; x++)
    {
      for (int y=0; y < 4; y++)
      {
        m[x*4 + y] = 
          m0[x*4+0] * m1[y+ 0] +
          m0[x*4+1] * m1[y+ 4] +
          m0[x*4+2] * m1[y+ 8] +
          m0[x*4+3] * m1[y+12];
      }
    }
    return m;
  }

  // create a matrix to perform a translation
  // input:   the translation (x,y,z)
  // returns: the corresponding 4x4 matrix
  public static float[] translation(float x, float y, float z)
  {
    float m[] = identity();
    m[3]  = x;
    m[7]  = y;
    m[11] = z;
    return m;
  }

  // create a matrix to perform a translation
  // input:   the translation  as a float vector t
  // returns: the corresponding 4x4 matrix
  public static float[] translation(float[] t)
  {
    float m[] = identity();
    m[3]  = t[0];
    m[7]  = t[1];
    m[11] = t[2];
    return m;
  }

  // create a matrix to perform scaling
  // input:  a scaling factor for each x, y and z dimension
  // returns:the 4x4 matrix that will perform the scaling
  public static float[] scale(float s1, float s2, float s3)
  {
    float m[] = identity();
    m[0]=s1;
    m[5]=s2;
    m[10]=s3;
    return m;
  }

  // create a matrix to perform scaling
  // input:  a single scaling factor for each x, y and z dimension
  // returns:the 4x4 matrix that will perform the scaling
  public static float[] scale(float s)
  {
    return scale(s, s, s);
  }

  // create a matrix to do a rotation about the x-axis
  // input:   the rotation angle, in degrees
  // returns: the 4x4 matrix with which to perform the rotation
  public static float[] rotationX(float angleDeg)
  {
    float m[] = identity();
    float angleRad = (float)Math.toRadians(angleDeg);
    float ca = (float)Math.cos(angleRad);
    float sa = (float)Math.sin(angleRad);
    m[ 5] =  ca;
    m[ 6] = -sa;
    m[ 9] =  sa;
    m[10] =  ca;
    return m;
  }

  // create a matrix to do a rotation about the y-axis
  // input:   the rotation angle, in degrees
  // returns: the 4x4 matrix with which to perform the rotation
  public static float[] rotationY(float angleDeg)
  {
    float m[] = identity();
    float angleRad = (float)Math.toRadians(angleDeg);
    float ca = (float)Math.cos(angleRad);
    float sa = (float)Math.sin(angleRad);
    m[ 0] =  ca;
    m[ 2] =  sa;
    m[ 8] = -sa;
    m[10] =  ca;
    return m;
  }

  // create a matrix to do a rotation about the z-axis
  // input:   the rotation angle, in degrees
  // returns: the 4x4 matrix with which to perform the rotation
  public static float[] rotationZ(float angleDeg)
  {
    float m[] = identity();
    float angleRad = (float)Math.toRadians(angleDeg);
    float ca = (float)Math.cos(angleRad);
    float sa = (float)Math.sin(angleRad);
    m[0] =  ca;
    m[1] = -sa;
    m[4] =  sa;
    m[5] =  ca;

    return m;
  }

  // create a matrix to do a rotation about the an axis
  // input:   angleDeg The rotation angle, in degrees
  //			axis The axis to rotate around
  // returns: the 4x4 matrix with which to perform the rotation
  public static float[] rotation(float angleDeg, float[] axis)
  {
    float[] m;
    float[] a   = normalize(axis);
    float d     = (float)Math.sqrt((double)(a[1]*a[1]+a[2]*a[2]));
    if (d!=0)
    {
      float[] rx  = identity();
      float[] rxt = identity();

      rx[5] = a[2]/d;  
      rxt[5] = rx[5];
      rx[6] = -a[1]/d; 
      rxt[9] = rx[6];
      rx[9] = a[1]/d;  
      rxt[6] = rx[9];
      rx[10]= rx[5];  
      rxt[10] = rx[10];

      float[] ry  = identity();
      float[] ryt = identity();
      ry[0] = d;       
      ryt[0] = d;
      ry[2] = -a[0];   
      ryt[8] = ry[2];
      ry[8] = a[0];    
      ryt[2] = ry[8];
      ry[10]= d;       
      ryt[10]=d;

      m = multiply(rxt, multiply(ryt, multiply(rotationZ(angleDeg), multiply(ry, rx))));
    }
    else if (axis[0] > 0)
    {
      m = rotationX(angleDeg);
    }
    else if (axis[0] < 0)
    {
      m = rotationX(-angleDeg);
    }
    else
    {
      m = identity();
    }

    return m;
  }

  // compute the crossproduct of (v1,v2,v3) and (w1,w2,w3)
  // input:   the vectors to be crossed
  // returns: the vector cross-product
  public static float[] crossprod( float v1, float v2, float v3, 
  float w1, float w2, float w3)
  {
    float crossp[];

    crossp=new float[3];
    crossp[0]=v2*w3-v3*w2;
    crossp[1]=v3*w1-v1*w3;
    crossp[2]=v1*w2-v2*w1;

    return crossp;
  }

  // compute the crossproduct of v and w
  // input:   the vectors to be crossed
  // returns: the vector cross-product
  public static float[] crossprod( float[] v, float[] w)
  {
    float crossp[];

    crossp=new float[3];
    crossp[0]=v[1]*w[2]-v[2]*w[1];
    crossp[1]=v[2]*w[0]-v[0]*w[2];
    crossp[2]=v[0]*w[1]-v[1]*w[0];

    return crossp;
  }
  
  //compute the crossproduct of v and w as PVectors
  // input: the vectors to be crossed
  // returns: the cross-product as an array
  public static PVector crossprod(PVector v, PVector w)
  {
    PVector crossp = new PVector();
    crossp.x= v.y*w.z - v.z*w.y;
    crossp.y= v.z*w.x - v.x*w.z;
    crossp.z= v.x*w.y - v.y*w.x;
    
    return crossp;
  }

  // normalize a vector
  // input: v, the vector to be normalized
  // returns:  the normalized vector
  public static float[] normalize(float[] v)
  {
    float norm;

    norm = (float) Math.sqrt((double)(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]));
    if (norm == 0.0f) norm = 1.0f;

    v[0] /= norm;
    v[1] /= norm;
    v[2] /= norm;

    return v;
  }
  
    // normalize a vector
  // input: v, the vector to be normalized
  // returns:  the normalized vector
  public static PVector normalizeV(PVector v)
  {
    float norm;

    norm = (float) Math.sqrt((double)(v.x*v.x+v.y*v.y+v.z*v.z));
    if (norm == 0.0f) norm = 1.0f;

    v.x /= norm;
    v.y /= norm;
    v.z /= norm;

    return v;
  }

  // compute the term-by-term product of 2 vectors
  // input:  v & w, the 2 vectors
  // returns: the vector (v1*w1,v2*w2,v3*w3)
  public static float[] prod(float[] v, float[] w)
  {
    float[] p=new float[v.length];
    for (int i=0;i<v.length;i++)
    {
      p[i]=v[i]*w[i];
    }

    return p;
  }

  // compute the dot product of 2 vectors
  // input:  2 vectors, v & w
  // returns: v.w
  public static float dot(float[] v, float[] w)
  {
    float d=v[0]*w[0]+v[1]*w[1]+v[2]*w[2];

    return d;
  }
  
  public static float dot(PVector v, PVector w)
  {
    float d=v.x*w.x+v.y*w.y+v.z*w.z;

    return d;
  }

  // compute the sum of 2 vectors
  // input:  2 vectors, v & w
  // returns: v+w	
  public static float[] add(float[] v, float[] w)
  {
    float[] s=new float[v.length];
    for (int i=0;i<v.length;i++)
    {
      s[i]=v[i]+w[i];
    }

    return s;
  }

  // compute the difference of 2 vectors
  // input:  2 vectors, v & w
  // returns: v-w
  public static float[] sub(float[] v, float[] w)
  {
    float[] s=new float[v.length];
    for (int i=0;i<v.length;i++)
    {
      s[i]=v[i]-w[i];
    }

    return s;
  }

  // scale a vector
  // input:   a The scaling factor
  //			v The vector to be scaled
  // returns: a*v
  public static float[] scale(float a, float[] v)
  {
    float[] s=new float[v.length];
    for (int i=0;i<v.length;i++)
    {
      s[i]=a*v[i];
    }

    return s;
  }

  // print out a matrix
  // input: m The matrix to be printed
  public static void printMatrix(float[] m)
  {
    for (int i=0;i<m.length;i++)
    {
      if (i%4==0) System.out.println();
      System.out.print(m[i]+" ");
    }
  }
}
