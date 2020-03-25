
import numpy as np
def ralign(X,Y):
    m, n = X.shape

    mx = X.mean(1)
    my = Y.mean(1)
    Xc =  X - np.tile(mx, (n, 1)).T
    Yc =  Y - np.tile(my, (n, 1)).T

    sx = np.mean(np.sum(Xc*Xc, 0))
    sy = np.mean(np.sum(Yc*Yc, 0))

    Sxy = np.dot(Yc, Xc.T) / n
    # print("Sxy= ")
    # print(Sxy)
    U,D,V = np.linalg.svd(Sxy,full_matrices=True,compute_uv=True)
    V=V.T.copy()
    #print U,"\n\n",D,"\n\n",V
    r = np.rank(Sxy)
    d = np.linalg.det(Sxy)
    S = np.eye(m)
    if r > (m - 1):
        if ( np.det(Sxy) < 0 ):
            S[m, m] = -1;
        elif (r == m - 1):
            if (np.det(U) * np.det(V) < 0):
                S[m, m] = -1
        else:
            R = np.eye(2)
            c = 1
            t = np.zeros(2)
            return R,c,t

    R = np.dot( np.dot(U, S ), V.T)

    c = np.trace(np.dot(np.diag(D), S)) / sx
    t = my - c * np.dot(R, mx)

    return R,c,t


# Run an example test
# We have 3 points in 3D. Every point is a column vector of this matrix A
# A=np.array([[0.57215 ,  0.37512 ,  0.37551] ,[0.23318 ,  0.86846 ,  0.98642],[ 0.79969 ,  0.96778 ,  0.27493]])
# # Deep copy A to get B
# B=A.copy()
# # and sum a translation on z axis (3rd row) of 10 units
# B[2,:]=B[2,:]+10

A=np.array([[0.00235840000000000,-2.64238020000000,-1.23690990000000] ,[0.00378470000000000,0.899052100000000,0.597713200000000],[0.0225208000000000,3.72580000000000,2.55591490000000]])
# Deep copy A to get B
B=np.array([[0,36.9620589166485,16.3664759546485] ,[0,-0.869759270921200,-0.291515240446200],[0,40.8037785142270,28.0412167161270]])
# and sum a translation on z axis (3rd row) of 10 units


# Reconstruct the transformation with ralign.ralign
R, c, t = ralign(A,B)
print ("Rotation matrix=")
print (R)
print ("Scaling coefficient=",c,)
print ("Translation vector=",t)
